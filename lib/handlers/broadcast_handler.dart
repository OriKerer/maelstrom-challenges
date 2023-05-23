import 'handler_base.dart';
import 'package:maelstrom_dart/store.dart';

class BroadcastHandler extends HandlerBase<MessageBodyBroadcast, MessageBody> {
  final Store _store;
  BroadcastHandler(this._store);
  @override
  Future<MessageBody> handle(
      RequestContext context, MessageBodyBroadcast message) async {
    _store.addPending(message.message);

    return MessageBody(
      type: "broadcast_ok",
    );
  }
}
