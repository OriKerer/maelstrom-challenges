import 'package:maelstrom_dart/message.dart';
export 'package:maelstrom_dart/message.dart';

abstract class HandlerBase<T extends MessageBody, S extends MessageBody> {
  S handle(T message);
  T Function(Map<String, dynamic>) get fromJson;
}
