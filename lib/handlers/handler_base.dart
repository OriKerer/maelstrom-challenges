import 'package:maelstrom_echo/message.dart';
export 'package:maelstrom_echo/message.dart';

abstract class HandlerBase<T extends MessageBody, S extends MessageBody> {
  S handle(T message);
  T Function(Map<String, dynamic>) get fromJson;
}
