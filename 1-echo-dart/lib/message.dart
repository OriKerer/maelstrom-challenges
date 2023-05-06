import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class MessageHeader {
  String src;
  String dest;

  MessageHeader(this.src, this.dest);
  Map<String, dynamic> toJson() => _$MessageHeaderToJson(this);
  factory MessageHeader.fromJson(Map<String, dynamic> json) =>
      _$MessageHeaderFromJson(json);
}

@JsonSerializable()
class MessageBody {
  String type;
  @JsonKey(name: "msg_id")
  int? id;
  @JsonKey(name: "in_reply_to")
  int? inReplyTo;
  MessageBody({required this.type, this.id, this.inReplyTo});
  Map<String, dynamic> toJson() => _$MessageBodyToJson(this);
  factory MessageBody.fromJson(Map<String, dynamic> json) =>
      _$MessageBodyFromJson(json);
}
