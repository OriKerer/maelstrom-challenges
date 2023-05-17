import 'handler_base.dart';
import 'package:maelstrom_dart/store.dart';

class BroadcastHandler extends HandlerBase<MessageBodyBroadcast, MessageBody> {
  final Store _store;

  BroadcastHandler(this._store);
  @override
  Future<MessageBody> handle(
      RequestContext context, MessageBodyBroadcast message) async {
    _store.add(message.message);
    context.neighboringNodes.where((e) => e != context.src).forEach((e) {
      context.sendRPC(message, e, null);
    });
    return MessageBody(
        type: "broadcast_ok",
        inReplyTo: message.id,
        id: context.generateMessageId());
  }

  @override
  MessageBodyBroadcast Function(Map<String, dynamic>) get fromJson =>
      MessageBodyBroadcast.fromJson;
}
