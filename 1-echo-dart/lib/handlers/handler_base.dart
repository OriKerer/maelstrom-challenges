import 'package:maelstrom_echo/message.dart';
export 'package:maelstrom_echo/message.dart';

import "../node.dart";
export '../node.dart';

abstract class HandlerBase<T extends MessageBody, S extends MessageBody> {
  S handle(T message);
  Type get requestType {
    return T;
  }
}
