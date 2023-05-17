import 'dart:collection';
import 'dart:io';
import 'package:maelstrom_dart/handlers/adhoc_handler.dart';
import 'package:maelstrom_dart/handlers/handler_base.dart';
import 'dart:convert';
import 'package:maelstrom_dart/error.dart';
import 'package:maelstrom_dart/rpc_manager.dart';
import 'package:maelstrom_dart/topology.dart';

class MaelstromNode {
  String _id = '';
  List<String> _nodes = [];
  final Map<String, HandlerBase> requestHandlers = {};
  late RPCManager _rpcManager;
  final Topology topology = Topology();

  String get id => _id;
  UnmodifiableListView<String> get cluster => UnmodifiableListView(_nodes);
  RPCManager get rpcManager => _rpcManager;

  MaelstromNode() {
    requestHandlers['init'] =
        AdHocHandler<MessageBodyInit, MessageBody>((context, message) async {
      _id = message.ownId;
      _nodes = message.nodeIds;
      return MessageBody(inReplyTo: message.id!, type: 'init_ok');
    }, () => MessageBodyInit.fromJson);

    requestHandlers['topology'] =
        AdHocHandler<MessageBodyTopology, MessageBody>(
            (context, message) async {
      topology.initialize(message.topology, context.ownId);
      return MessageBody(
          type: 'topology_ok',
          id: context.generateMessageId(),
          inReplyTo: message.id);
    }, () => MessageBodyTopology.fromJson);

    _rpcManager = RPCManager(this);
  }

  void registerHandler(String messageType, HandlerBase handler) {
    if (requestHandlers.containsKey(messageType)) {
      throw ArgumentError.value(messageType,
          "A handler is already registered for this message type.");
    }
    requestHandlers[messageType] = handler;
  }

  void send(String dest, MessageBody body) {
    var fullJson = jsonEncode({
      'src': _id,
      'dest': dest,
      'body': body.toJson(),
    });
    stdout.nonBlocking.writeln(fullJson);
  }

  HandlerBase _getHandler(Map<String, dynamic> body) {
    String type = body['type'] ?? '';
    int? inReplyTo = body['in_reply_to'];

    // Check if a reply to a RPC request
    if (inReplyTo != null) {
      var h = _rpcManager.getReplyHandler(inReplyTo, type);
      if (h == null) {
        throw MaelstromException(
            code: MaelstromErrorCode.preconditionFailed,
            description: 'Node does not have pending request "$inReplyTo"');
      }
      return h;
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
      var request = handler.fromJson(body);
      return await handler.handle(context, request);
    } on MaelstromException catch (e, s) {
      return MessageBodyError(
          code: e.code, inReplyTo: body['msg_id'], text: '$e: $s');
    } catch (e, s) {
      return MessageBodyError(
          code: MaelstromErrorCode.crash,
          inReplyTo: body['msg_id'],
          text: '$e: $s');
    }
  }

  void _handleInput(String input) async {
    var requestJsonMap = jsonDecode(input) as Map<String, dynamic>;
    var context = RequestContext(this, requestJsonMap['src']);
    var response = await _requestHandlerWrapper(context, requestJsonMap);
    if (response != null) {
      send(requestJsonMap['src'], response);
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
