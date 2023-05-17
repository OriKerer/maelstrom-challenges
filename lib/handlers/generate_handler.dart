import 'dart:math';

import 'handler_base.dart';

class GenerateHandler extends HandlerBase<MessageBody, MessageBodyGenerateOk> {
  int runningId = 0;
  final Random rand = Random();

  String generateUUID(String ownId) {
    var id = ownId.toString().substring(1); // node id index n1 -> 1
    var t =
        DateTime.now().millisecondsSinceEpoch.toRadixString(36); // timestamp
    var r = rand.nextInt(pow(36, 4).toInt()).toRadixString(36); // random
    return '$id$t$r';
  }

  @override
  Future<MessageBodyGenerateOk> handle(
      RequestContext context, MessageBody message) async {
    return MessageBodyGenerateOk(
        id: context.generateMessageId(),
        inReplyTo: message.id,
        generatedId: generateUUID(context.ownId));
  }

  @override
  MessageBody Function(Map<String, dynamic>) get fromJson =>
      MessageBody.fromJson;
}
