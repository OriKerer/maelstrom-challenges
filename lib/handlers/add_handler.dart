import 'handler_base.dart';
import 'package:maelstrom_dart/store.dart';

class AddHandler extends HandlerBase<MessageBodyAdd, MessageBody> {
  final Store _store;
  AddHandler(this._store);
  @override
  Future<MessageBody> handle(
      RequestContext context, MessageBodyAdd message) async {
    _store.addPending(message.delta);

    return MessageBody(
      type: "add_ok",
    );
  }
}
