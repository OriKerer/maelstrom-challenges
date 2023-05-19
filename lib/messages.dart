import 'package:json_annotation/json_annotation.dart';
import 'package:maelstrom_dart/error.dart';

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
  MessageBody({
    required this.type,
  });
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

  MessageBodyInit({required this.ownId, required this.nodeIds})
      : super(type: "init");
  @override
  Map<String, dynamic> toJson() => _$MessageBodyInitToJson(this);
  factory MessageBodyInit.fromJson(Map<String, dynamic> json) =>
      _$MessageBodyInitFromJson(json);
}

@JsonSerializable()
class MessageBodyEcho extends MessageBody {
  String echo;

  MessageBodyEcho({
    required this.echo,
  }) : super(type: 'echo');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyEchoToJson(this);
  factory MessageBodyEcho.fromJson(Map<String, dynamic> json) =>
      _$MessageBodyEchoFromJson(json);
}

@JsonSerializable()
class MessageBodyError extends MessageBody {
  MaelstromErrorCode code;
  String text;

  MessageBodyError({required this.code, this.text = ""}) : super(type: 'error');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyErrorToJson(this);
  factory MessageBodyError.fromJson(Map<String, dynamic> json) =>
      _$MessageBodyErrorFromJson(json);
}

@JsonSerializable()
class MessageBodyGenerateOk extends MessageBody {
  @JsonKey(name: "id")
  String generatedId;

  MessageBodyGenerateOk({
    required this.generatedId,
  }) : super(type: 'generate_ok');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyGenerateOkToJson(this);
  factory MessageBodyGenerateOk.fromJson(Map<String, dynamic> json) =>
      _$MessageBodyGenerateOkFromJson(json);
}

@JsonSerializable()
class MessageBodyBroadcast extends MessageBody {
  int message;
  String? valueId;

  MessageBodyBroadcast({
    required this.message,
    this.valueId,
  }) : super(type: 'broadcast');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyBroadcastToJson(this);
  factory MessageBodyBroadcast.fromJson(Map<String, dynamic> json) =>
      _$MessageBodyBroadcastFromJson(json);
}

@JsonSerializable()
class MessageBodyReadOk extends MessageBody {
  List<int> messages;

  MessageBodyReadOk({required this.messages}) : super(type: 'read_ok');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyReadOkToJson(this);
  factory MessageBodyReadOk.fromJson(Map<String, dynamic> json) =>
      _$MessageBodyReadOkFromJson(json);
}

@JsonSerializable()
class MessageBodyTopology extends MessageBody {
  Map<String, List<String>> topology;

  MessageBodyTopology({required this.topology}) : super(type: 'topology');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyTopologyToJson(this);
  factory MessageBodyTopology.fromJson(Map<String, dynamic> json) =>
      _$MessageBodyTopologyFromJson(json);
}
