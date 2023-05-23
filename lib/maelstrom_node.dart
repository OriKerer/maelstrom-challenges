import 'dart:async';
import 'dart:io';
import 'package:maelstrom_dart/handlers/adhoc_handler.dart';
import 'package:maelstrom_dart/handlers/handler_base.dart';
import 'dart:convert';
import 'package:maelstrom_dart/error.dart';
import 'package:maelstrom_dart/log.dart';
import 'package:maelstrom_dart/rpc_client.dart';
import 'package:maelstrom_dart/topology.dart';
import 'package:maelstrom_dart/uuid.dart';

class MaelstromNode {
  late final String _id;
  late final List<String> _nodes;
  final Map<String, HandlerBase> requestHandlers = {};
  final Topology topology = Topology();
  late final UUID uuid;
  final List<void Function()> initNotificationList = [];

  String get id => _id;
  List<String> get cluster => _nodes;

  MaelstromNode() {
    requestHandlers['init'] =
        AdHocHandler<MessageBodyInit, MessageBody>((context, message) async {
      _id = message.ownId;
      _nodes = message.nodeIds;
      uuid = UUID(_id);
      for (var f in initNotificationList) {
        f();
      }
      log('$id finished init');
      return MessageBody(type: 'init_ok');
    });
  }

  void registerHandler(String messageType, HandlerBase handler) {
    if (requestHandlers.containsKey(messageType)) {
      throw ArgumentError.value(messageType,
          "A handler is already registered for this message type.");
    }
    requestHandlers[messageType] = handler;
  }

  HandlerBase? _getHandler(String type, int? inReplyTo) {
    // Check if a reply to a RPC request
    if (inReplyTo != null) {
      var handler = rpcClient.getPendingRPCHandler(inReplyTo);
      if (handler == null) {
        throw MaelstromException(
            code: MaelstromErrorCode.preconditionFailed,
            desc: 'Node does not have pending request "$inReplyTo"');
      }
      return handler;
    }
    if (!requestHandlers.containsKey(type)) {
      throw MaelstromException(
          code: MaelstromErrorCode.notSupported,
          desc: 'Node does not support RPC type: $type');
    }
    return requestHandlers[type]!;
  }

  Future<MessageBody?> _requestHandlerWrapper(
      RequestContext context, Map<String, dynamic> msg) async {
    Map<String, dynamic> body = msg['body'];

    try {
      var handler = _getHandler(body['type'], body['in_reply_to']);
      var requestBody = fromJson(body);

      var response = await handler?.handle(context, requestBody);

      return response;
    } on MaelstromException catch (e, s) {
      return MessageBodyError(code: e.code, text: '$e: $s');
    } catch (e, s) {
      return MessageBodyError(code: MaelstromErrorCode.crash, text: '$e: $s');
    }
  }

  void _handleInput(String input) async {
    // log("<<< $input");
    var requestJsonMap = jsonDecode(input) as Map<String, dynamic>;
    var context = RequestContext(requestJsonMap['src']);
    var response = await _requestHandlerWrapper(context, requestJsonMap);
    if (response != null) {
      rpcClient.send(context.src, response,
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

final node = MaelstromNode();
