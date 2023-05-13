import 'dart:math';

import 'rpc_handler_base.dart';

class GenerateHandler
    extends RPCHandlerBase<MessageBody, MessageBodyGenerateOk> {
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
        id: message.id,
        inReplyTo: message.id,
        generatedId: generateUUID(context.id));
  }

  @override
  MessageBody Function(Map<String, dynamic>) get fromJson =>
      MessageBody.fromJson;
}
