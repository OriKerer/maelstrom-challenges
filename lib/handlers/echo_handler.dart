import 'rpc_handler_base.dart';

class EchoHandler extends RPCHandlerBase<MessageBodyEcho, MessageBodyEcho> {
  @override
  Future<MessageBodyEcho> handle(
      RequestContext context, MessageBodyEcho message) async {
    message.type = "echo_ok";
    message.inReplyTo = message.id;
    return message;
  }

  @override
  MessageBodyEcho Function(Map<String, dynamic>) get fromJson =>
      MessageBodyEcho.fromJson;
}
