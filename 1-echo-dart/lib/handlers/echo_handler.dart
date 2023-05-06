import './handler_base.dart';

class EchoHandler extends HandlerBase<MessageBody, MessageBody> {
  @override
  MessageBody handle(MessageBody message) {
    message.type = "echo_ok";
    return message;
  }
}
