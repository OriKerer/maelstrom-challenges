import 'handler_base.dart';
import 'package:maelstrom_dart/store.dart';

class BroadcastHandler extends HandlerBase<MessageBodyBroadcast, MessageBody> {
  final Store _store;

  BroadcastHandler(this._store);
  @override
  Future<MessageBody> handle(
      RequestContext context, MessageBodyBroadcast message) async {
    if (message.valueId == null) {
      var uuid = context.uuid.generate();
      _store.add(uuid, message.message);
      message.valueId = uuid;
      for (var node in context.neighboringNodes) {
        context.sendRPC(message, node);
      }
    } else if (!_store.exists(message.valueId!)) {
      _store.add(message.valueId!, message.message);
      for (var node
          in context.neighboringNodes.where((e) => e != context.src)) {
        context.sendRPC(message, node);
      }
    }
    return MessageBody(
      type: "broadcast_ok",
    );
  }

  @override
  MessageBodyBroadcast Function(Map<String, dynamic>) get fromJson =>
      MessageBodyBroadcast.fromJson;
}
