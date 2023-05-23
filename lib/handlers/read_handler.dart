import 'handler_base.dart';
import 'package:maelstrom_dart/store.dart';

class ReadHandler extends HandlerBase<MessageBody, MessageBodyReadOk> {
  @override
  Future<MessageBodyReadOk> handle(
      RequestContext context, MessageBody message) async {
    return MessageBodyReadOk(
        messages: broadcastStore.data.values
            .map((e) => e.values)
            .expand((e) => e)
            .map((e) => e as int)
            .toList());
  }
}
