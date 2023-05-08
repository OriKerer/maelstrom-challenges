import 'package:maelstrom_dart/messages.dart';
export 'package:maelstrom_dart/messages.dart';

abstract class HandlerBase<T extends MessageBody, S extends MessageBody> {
  S handle(T message);
  T Function(Map<String, dynamic>) get fromJson;
}
