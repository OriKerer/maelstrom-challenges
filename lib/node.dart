import 'dart:io';
import 'package:maelstrom_dart/handlers/handler_base.dart';
import 'dart:convert';

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

  void run() {
    while (true) {
      var line = stdin.readLineSync();
      stderr.writeln("Request: '$line'");
      var requestJsonMap = jsonDecode(line!) as Map<String, dynamic>;
      var type = requestJsonMap['body']['type'];
      var handler = handlers[type]!;
      var request = handler.fromJson(requestJsonMap['body']);

      var response = handler.handle(request);
      var responseJson = jsonEncode({
        'src': requestJsonMap['dest'],
        'dest': requestJsonMap['src'],
        'body': response.toJson(),
      });
      stderr.writeln("Request: '$responseJson'");
      stdout.writeln(responseJson);
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
