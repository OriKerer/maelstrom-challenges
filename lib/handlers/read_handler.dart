import 'handler_base.dart';
import 'package:maelstrom_dart/store.dart';

class ReadHandler extends HandlerBase<MessageBody, MessageBodyReadOk> {
  final Store _store;

  ReadHandler(this._store);
  @override
  Future<MessageBodyReadOk> handle(
      RequestContext context, MessageBody message) async {
    var values = _store.data.values;
    return MessageBodyReadOk(
        value: values.isEmpty
            ? 0
            : _store.data.values
                .map((e) => e.values)
                .expand((e) => e)
                .map((e) => e as int)
                .reduce((v, e) => v + e));
  }
}
