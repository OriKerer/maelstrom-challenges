import 'package:maelstrom_dart/messages.dart';
import 'package:maelstrom_dart/request_context.dart';
export 'package:maelstrom_dart/messages.dart';
export 'package:maelstrom_dart/request_context.dart';

abstract class HandlerBase<T extends MessageBody, S extends MessageBody> {
  S handle(RequestContext context, T message);
  T Function(Map<String, dynamic>) get fromJson;
}
