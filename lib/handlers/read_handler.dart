import 'handler_base.dart';
import 'package:maelstrom_dart/store.dart';

class ReadHandler extends HandlerBase<MessageBody, MessageBodyReadOk> {
  final Store _store;

  ReadHandler(this._store);
  @override
  Future<MessageBodyReadOk> handle(
      RequestContext context, MessageBody message) async {
    return MessageBodyReadOk(
      messages: _store.data,
    );
  }
}
