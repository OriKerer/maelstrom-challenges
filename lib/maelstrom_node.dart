import 'dart:collection';
import 'dart:io';
import 'package:maelstrom_dart/handlers/rpc_handler_base.dart';
import 'dart:convert';
import 'package:maelstrom_dart/error.dart';

class MaelstromNode extends RPCHandlerBase<MessageBodyInit, MessageBody> {
  String _id = '';
  List<String> _nodes = [];
  final Map<String, RPCHandlerBase> rpcHandlers = {};

  MaelstromNode() {
    rpcHandlers['init'] = this;
  }

  void registerHandler(String messageType, RPCHandlerBase handler) {
    if (rpcHandlers.containsKey(messageType)) {
      throw ArgumentError.value(messageType,
          "A handler is already registered for this message type.");
    }
    rpcHandlers[messageType] = handler;
  }

  void send(String dest, MessageBody body) {
    var fullJson = jsonEncode({
      'src': _id,
      'dest': dest,
      'body': body.toJson(),
    });
    stdout.nonBlocking.writeln(fullJson);
  }

  Future<MessageBody> rpcHandlerWrapper(
      RequestContext context, Map<String, dynamic> msg) async {
    Map<String, dynamic> body = msg['body'];
    String type = body['type'] ?? '';

    if (!rpcHandlers.containsKey(type)) {
      return MessageBodyError(
          code: MaelstromErrorCode.notSupported,
          inReplyTo: body['msg_id'],
          text: 'Node does not support RPC type: $type');
    }

    var handler = rpcHandlers[type]!;

    try {
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

  void handleInput(String input) async {
    var requestJsonMap = jsonDecode(input) as Map<String, dynamic>;
    var context = RequestContext(
        this, _id, UnmodifiableListView(_nodes), requestJsonMap['src']);
    var response = await rpcHandlerWrapper(context, requestJsonMap);
    if (!context.requestAlreadyReplied) {
      send(requestJsonMap['src'], response);
    }
  }

  void run() {
    stdin
        .asBroadcastStream()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .forEach(handleInput);
  }

  @override
  Future<MessageBody> handle(
      RequestContext context, MessageBodyInit message) async {
    _id = message.ownId;
    _nodes = message.nodeIds;
    return MessageBody(inReplyTo: message.id!, type: 'init_ok');
  }

  @override
  MessageBodyInit Function(Map<String, dynamic> p1) get fromJson =>
      MessageBodyInit.fromJson;
}
