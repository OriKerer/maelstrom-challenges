import 'handler_base.dart';

class EchoHandler extends HandlerBase<MessageBodyEcho, MessageBodyEcho> {
  @override
  Future<MessageBodyEcho> handle(
      RequestContext context, MessageBodyEcho message) async {
    message.type = "echo_ok";
    return message;
  }
}
