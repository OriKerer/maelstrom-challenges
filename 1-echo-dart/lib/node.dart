import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'package:maelstrom_echo/handlers/handler_base.dart';
import 'dart:convert';

part 'node.g.dart';

class Node extends HandlerBase<MessageBodyInit, MessageBody> {
  late String id;
  late List<String> nodes;
  final Map<String, HandlerBase> handlers = {};

  Node() {
    handlers['init'] = this;
  }

  void _init(String id, List<String> nodes) {
    this.id = id;
    this.nodes = nodes;
  }

  void registerHandler(String messageType, HandlerBase handler) {
    if (handlers.containsKey(messageType)) {
      throw ArgumentError.value(messageType,
          "An handler is already registered for this message type.");
    }
    handlers[messageType] = handler;
  }

  void run() {
    while (true) {
      stderr.writeln("@@@@@ Started");
      var line = stdin.readLineSync();
      stderr.writeln("Request: '$line'");
      // '{"src": "1", "dest": "2", "body": {"type": "init", "node_id": "a", "node_ids" : ["a"], "msg_id": 2}}'
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
    _init(message.ownId, message.nodeIds);
    return MessageBody(inReplyTo: message.messageId!, type: 'init_ok');
  }

  @override
  MessageBodyInit Function(Map<String, dynamic> p1) get fromJson =>
      MessageBodyInit.fromJson;
}

@JsonSerializable()
class MessageBodyInit extends MessageBody {
  @JsonKey(name: "node_id")
  String ownId;
  @JsonKey(name: "node_ids")
  List<String> nodeIds;

  MessageBodyInit(
      {required this.ownId, required this.nodeIds, required int messageId})
      : super(type: "init", messageId: messageId);
  @override
  Map<String, dynamic> toJson() => _$MessageBodyInitToJson(this);
  factory MessageBodyInit.fromJson(Map<String, dynamic> json) =>
      _$MessageBodyInitFromJson(json);
}
