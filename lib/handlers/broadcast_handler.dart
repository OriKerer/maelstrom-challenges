import 'handler_base.dart';
import 'package:maelstrom_dart/store.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';

class BroadcastHandler extends HandlerBase<MessageBodyBroadcast, MessageBody> {
  @override
  Future<MessageBody> handle(
      RequestContext context, MessageBodyBroadcast message) async {
    broadcastStore.add(node.vclock.vector[node.id]!, message.message, node.id);

    return MessageBody(
      type: "broadcast_ok",
    );
  }
}
