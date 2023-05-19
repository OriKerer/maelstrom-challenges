import 'dart:io';
import 'package:maelstrom_dart/handlers/adhoc_handler.dart';
import 'package:maelstrom_dart/handlers/handler_base.dart';
import 'dart:convert';
import 'package:maelstrom_dart/error.dart';
import 'package:maelstrom_dart/rpc_manager.dart';
import 'package:maelstrom_dart/topology.dart';
import 'package:maelstrom_dart/uuid.dart';

class MaelstromNode {
  late final String _id;
  late final List<String> _nodes;
  final Map<String, HandlerBase> requestHandlers = {};
  late final RPCManager _rpcManager;
  final Topology topology = Topology();
  late final UUID uuid;

  String get id => _id;
  List<String> get cluster => _nodes;
  RPCManager get rpcManager => _rpcManager;

  MaelstromNode() {
    requestHandlers['init'] =
        AdHocHandler<MessageBodyInit, MessageBody>((context, message) async {
      _id = message.ownId;
      _nodes = message.nodeIds;
      uuid = UUID(_id);
      return MessageBody(type: 'init_ok');
    }, () => MessageBodyInit.fromJson);

    requestHandlers['topology'] =
        AdHocHandler<MessageBodyTopology, MessageBody>(
            (context, message) async {
      topology.initialize(message.topology, context.ownId);
      return MessageBody(
        type: 'topology_ok',
      );
    }, () => MessageBodyTopology.fromJson);

    _rpcManager = RPCManager();
  }

  void registerHandler(String messageType, HandlerBase handler) {
    if (requestHandlers.containsKey(messageType)) {
      throw ArgumentError.value(messageType,
          "A handler is already registered for this message type.");
    }
    requestHandlers[messageType] = handler;
  }

  HandlerBase? _getHandler(Map<String, dynamic> body) {
    String type = body['type'] ?? '';
    int? inReplyTo = body['in_reply_to'];

    // Check if a reply to a RPC request
    if (inReplyTo != null) {
      var pendingRPC = _rpcManager.getPendingRPC(inReplyTo);
      if (pendingRPC == null) {
        throw MaelstromException(
            code: MaelstromErrorCode.preconditionFailed,
            description: 'Node does not have pending request "$inReplyTo"');
      }
      return pendingRPC.handler;
    }
    if (!requestHandlers.containsKey(type)) {
      throw MaelstromException(
          code: MaelstromErrorCode.notSupported,
          description: 'Node does not support RPC type: $type');
    }
    return requestHandlers[type]!;
  }

  Future<MessageBody?> _requestHandlerWrapper(
      RequestContext context, Map<String, dynamic> msg) async {
    Map<String, dynamic> body = msg['body'];

    try {
      var handler = _getHandler(body);
      return await handler?.handle(context, handler.fromJson(body));
    } on MaelstromException catch (e, s) {
      return MessageBodyError(code: e.code, text: '$e: $s');
    } catch (e, s) {
      return MessageBodyError(code: MaelstromErrorCode.crash, text: '$e: $s');
    }
  }

  void _handleInput(String input) async {
    // stderr.writeln("### [${DateTime.now()}] $input");
    var requestJsonMap = jsonDecode(input) as Map<String, dynamic>;
    var context = RequestContext(this, requestJsonMap['src']);
    var response = await _requestHandlerWrapper(context, requestJsonMap);
    if (response != null) {
      context.send(context.src, response,
          inReplyTo: requestJsonMap['body']['msg_id']);
    }
  }

  void run() {
    stdin
        .asBroadcastStream()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .forEach(_handleInput);
  }
}
