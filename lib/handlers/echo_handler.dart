import './handler_base.dart';

class EchoHandler extends HandlerBase<MessageBodyEcho, MessageBodyEcho> {
  @override
  MessageBodyEcho handle(RequestContext context, MessageBodyEcho message) {
    message.type = "echo_ok";
    message.inReplyTo = message.id;
    return message;
  }

  @override
  MessageBodyEcho Function(Map<String, dynamic>) get fromJson =>
      MessageBodyEcho.fromJson;
}
