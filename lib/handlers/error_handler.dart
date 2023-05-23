import 'package:maelstrom_dart/log.dart';

import 'handler_base.dart';

class ErrorHandler extends HandlerBase<MessageBodyError, MessageBody> {
  @override
  Future<MessageBody?> handle(
      RequestContext context, MessageBodyError message) async {
    log('Received error from ${context.src}: ${message.toJson()}');
    return null;
  }
}
