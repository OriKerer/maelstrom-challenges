import 'dart:math';

import 'package:maelstrom_dart/node.dart';

import './handler_base.dart';

class GenerateHandler extends HandlerBase<MessageBody, MessageBodyGenerateOk> {
  int runningId = 0;
  final Node node;
  final Random rand = Random();

  GenerateHandler(this.node);

  String generateUUID() {
    var id = node.id.toString().substring(1); // node id index n1 -> 1
    var t =
        DateTime.now().millisecondsSinceEpoch.toRadixString(36); // timestamp
    var r = rand.nextInt(pow(36, 4).toInt()).toRadixString(36); // random
    return '$id$t$r';
  }

  @override
  MessageBodyGenerateOk handle(MessageBody message) {
    return MessageBodyGenerateOk(
        id: message.id, inReplyTo: message.id, generatedId: generateUUID());
  }

  @override
  MessageBody Function(Map<String, dynamic>) get fromJson =>
      MessageBody.fromJson;
}
