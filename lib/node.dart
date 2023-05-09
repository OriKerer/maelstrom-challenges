import 'dart:io';
import 'package:maelstrom_dart/handlers/handler_base.dart';
import 'dart:convert';
import 'package:maelstrom_dart/error.dart';

class Node extends HandlerBase<MessageBodyInit, MessageBody> {
  late String id;
  late List<String> nodes;
  final Map<String, HandlerBase> handlers = {};

  Node() {
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
      'src': id,
      'dest': dest,
      'body': body.toJson(),
    });

    stdout.writeln(fullJson);
  }

  MessageBody handleWrapper(Map<String, dynamic> msg) {
    String type = msg['type'];
    Map<String, dynamic> body = msg['body'];

    if (!handlers.containsKey(type)) {
      return MessageBodyError(
          error: MaelstromError.notSupported,
          inReplyTo: body['msg_id'],
          text: 'Node does not support RPC type: $type');
    }

    var handler = handlers[type]!;

    try {
      var request = handler.fromJson(body);
      return handler.handle(request);
    } on MaelstromException catch (e) {
      return MessageBodyError(
          error: e.code, inReplyTo: body['msg_id'], text: e.toString());
    } catch (e) {
      return MessageBodyError(
          error: MaelstromError.crash,
          inReplyTo: body['msg_id'],
          text: e.toString());
    }
  }

  void run() {
    while (true) {
      var line = stdin.readLineSync();
      var requestJsonMap = jsonDecode(line!) as Map<String, dynamic>;

      var response = handleWrapper(requestJsonMap);

      send(requestJsonMap['src'], response);
    }
  }

  @override
  MessageBody handle(MessageBodyInit message) {
    id = message.ownId;
    nodes = message.nodeIds;
    return MessageBody(inReplyTo: message.id!, type: 'init_ok');
  }

  @override
  MessageBodyInit Function(Map<String, dynamic> p1) get fromJson =>
      MessageBodyInit.fromJson;
}
