import 'handler_base.dart';
import 'package:maelstrom_dart/store.dart';

class ReadHandlerChallenge3
    extends HandlerBase<MessageBody, MessageBodyReadOkChallenge3> {
  final Store _store;

  ReadHandlerChallenge3(this._store);
  @override
  Future<MessageBodyReadOkChallenge3> handle(
      RequestContext context, MessageBody message) async {
    return MessageBodyReadOkChallenge3(
        messages: _store.data.values
            .map((e) => e.values)
            .expand((e) => e)
            .map((e) => e as int)
            .toList());
  }
}
