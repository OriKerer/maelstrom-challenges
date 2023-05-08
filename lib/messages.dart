import 'package:json_annotation/json_annotation.dart';

part 'messages.g.dart';

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

@JsonSerializable()
class MessageBodyInit extends MessageBody {
  @JsonKey(name: "node_id")
  String ownId;
  @JsonKey(name: "node_ids")
  List<String> nodeIds;

  MessageBodyInit({required this.ownId, required this.nodeIds, required int id})
      : super(type: "init", id: id);
  @override
  Map<String, dynamic> toJson() => _$MessageBodyInitToJson(this);
  factory MessageBodyInit.fromJson(Map<String, dynamic> json) =>
      _$MessageBodyInitFromJson(json);
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
