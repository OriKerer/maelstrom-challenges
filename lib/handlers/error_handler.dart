import 'dart:io';

import 'handler_base.dart';

class ErrorHandler extends HandlerBase<MessageBodyError, MessageBody> {
  @override
  Future<MessageBody?> handle(
      RequestContext context, MessageBodyError message) async {
    stderr.writeln(
        '[${DateTime.now()}] Received error from ${context.src}: ${message.toJson()}');
    return null;
  }
}
