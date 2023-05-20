import 'package:maelstrom_dart/messages.dart';
import 'package:maelstrom_dart/request_context.dart';
export 'package:maelstrom_dart/messages.dart';
export 'package:maelstrom_dart/request_context.dart';

abstract class HandlerBase<REQUEST extends MessageBody,
    RESPONSE extends MessageBody> {
  Future<RESPONSE?> handle(RequestContext context, REQUEST message);
}
