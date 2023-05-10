import 'dart:collection';
import 'dart:io';
import 'package:maelstrom_dart/handlers/handler_base.dart';
import 'dart:convert';
import 'package:maelstrom_dart/error.dart';

class MaelstromNode extends HandlerBase<MessageBodyInit, MessageBody> {
  String _id = '';
  List<String> _nodes = [];
  final Map<String, HandlerBase> handlers = {};

  MaelstromNode() {
    handlers['init'] = this;
  }

  void registerHandler(String messageType, HandlerBase handler) {
    if (handlers.containsKey(messageType)) {
      throw ArgumentError.value(messageType,
          "A handler is already registered for this message type.");
    }
    handlers[messageType] = handler;
  }

  void send(String dest, MessageBody body) {
    var fullJson = jsonEncode({
      'src': _id,
      'dest': dest,
      'body': body.toJson(),
    });
    stderr.writeln('sent: $fullJson');
    stdout.writeln(fullJson);
  }

  MessageBody handleWrapper(RequestContext context, Map<String, dynamic> msg) {
    Map<String, dynamic> body = msg['body'];
    String type = body['type'] ?? '';

    if (!handlers.containsKey(type)) {
      return MessageBodyError(
          code: MaelstromErrorCode.notSupported,
          inReplyTo: body['msg_id'],
          text: 'Node does not support RPC type: $type');
    }

    var handler = handlers[type]!;

    try {
      var request = handler.fromJson(body);
      return handler.handle(context, request);
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

  void run() {
    while (true) {
      var line = stdin.readLineSync();
      stderr.writeln('received: $line');
      var requestJsonMap = jsonDecode(line!) as Map<String, dynamic>;
      var context = RequestContext(
          this, _id, UnmodifiableListView(_nodes), requestJsonMap['src']);
      var response = handleWrapper(context, requestJsonMap);
      if (!context.requestAlreadyReplied) {
        send(requestJsonMap['src'], response);
      }
    }
  }

  @override
  MessageBody handle(RequestContext context, MessageBodyInit message) {
    _id = message.ownId;
    _nodes = message.nodeIds;
    return MessageBody(inReplyTo: message.id!, type: 'init_ok');
  }

  @override
  MessageBodyInit Function(Map<String, dynamic> p1) get fromJson =>
      MessageBodyInit.fromJson;
}
