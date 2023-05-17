import 'dart:io';

import 'handler_base.dart';

class ErrorHandler extends HandlerBase<MessageBodyError, MessageBody> {
  @override
  Future<MessageBody?> handle(
      RequestContext context, MessageBodyError message) async {
    stderr.writeln('Received error from ${context.src}: ${message.toJson()}');
    return null;
  }

  @override
  MessageBodyError Function(Map<String, dynamic>) get fromJson =>
      MessageBodyError.fromJson;
}
