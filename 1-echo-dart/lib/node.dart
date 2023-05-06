import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'package:maelstrom_echo/handlers/handler_base.dart';
import 'package:maelstrom_echo/message.dart';
import 'dart:convert';
import 'dart:mirrors';

part 'node.g.dart';

class Node extends HandlerBase<MessageBodyInit, MessageBody> {
  late String id;
  late List<String> nodes;
  final Map<String, HandlerBase> handlers = {};

  void _init(String id, List<String> nodes) {
    this.id = id;
    this.nodes = nodes;
  }

  void registerHandler(String messageType, HandlerBase hanlder) {
    if (handlers.containsKey(messageType)) {
      throw ArgumentError.value(messageType,
          "An handler is already registered for this message type.");
    }
    handlers[messageType] = hanlder;
  }

  void run() {
    while (true) {
      var line = stdin.readLineSync();
      stderr.writeln("Request: '$line'");
      var jsonMap = jsonDecode(line!) as Map<String, dynamic>;
      var type = jsonMap['body']['type'];
      var handler = handlers[type];
      var request = reflectClass(handler!.requestType)
          .invoke(Symbol("fromJson"), [jsonMap]);
      var response = handler.handle(request as dynamic);
      var responseJson = jsonEncode({
        'src': jsonMap['dest'],
        'dest': jsonMap['src'],
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
