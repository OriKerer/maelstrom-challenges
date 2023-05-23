import 'handler_base.dart';
import 'package:maelstrom_dart/store.dart';

class BroadcastHandler extends HandlerBase<MessageBodyBroadcast, MessageBody> {
  @override
  Future<MessageBody> handle(
      RequestContext context, MessageBodyBroadcast message) async {
    broadcastStore.addPending(message.message);

    return MessageBody(
      type: "broadcast_ok",
    );
  }
}
