import 'package:json_annotation/json_annotation.dart';
import './handler_base.dart';

part 'echo_handler.g.dart';

class EchoHandler extends HandlerBase<MessageBodyEcho, MessageBodyEcho> {
  @override
  MessageBodyEcho handle(MessageBodyEcho message) {
    message.type = "echo_ok";
    message.inReplyTo = message.id;
    return message;
  }

  @override
  MessageBodyEcho Function(Map<String, dynamic>) get fromJson =>
      MessageBodyEcho.fromJson;
}

@JsonSerializable()
class MessageBodyEcho extends MessageBody {
  String echo;

  MessageBodyEcho({required this.echo, int? id, int? inReplyTo, required type})
      : super(type: type, id: id, inReplyTo: inReplyTo);
  @override
  Map<String, dynamic> toJson() => _$MessageBodyEchoToJson(this);
  factory MessageBodyEcho.fromJson(Map<String, dynamic> json) =>
      _$MessageBodyEchoFromJson(json);
}
