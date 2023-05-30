import 'handler_base.dart';
import 'package:maelstrom_dart/store.dart';

class ReadHandler extends HandlerBase<MessageBody, MessageBodyReadOk> {
  final Store _store;

  ReadHandler(this._store);
  @override
  Future<MessageBodyReadOk> handle(
      RequestContext context, MessageBody message) async {
    return MessageBodyReadOk(
        value: _store.data.values
            .map((e) => e.values)
            .expand((e) => e)
            .map((e) => e as int)
            .reduce((v, e) => v + e));
  }
}
