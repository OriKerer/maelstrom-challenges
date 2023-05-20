import 'package:json_annotation/json_annotation.dart';
import 'package:maelstrom_dart/error.dart';

part 'messages.g.dart';

MessageBody fromJson(Map<String, dynamic> bodyMap) {
  return switch (bodyMap['type']) {
    'init' => _$MessageBodyInitFromJson,
    'echo' => _$MessageBodyEchoFromJson,
    'broadcast' => _$MessageBodyBroadcastFromJson,
    'error' => _$MessageBodyErrorFromJson,
    'generate_ok' => _$MessageBodyGenerateOkFromJson,
    'read_ok' => _$MessageBodyReadOkFromJson,
    'topology' => _$MessageBodyTopologyFromJson,
    _ => _$MessageBodyFromJson,
  }(bodyMap);
}

@JsonSerializable()
class MessageBody {
  String type;
  MessageBody({
    required this.type,
  });
  Map<String, dynamic> toJson() => _$MessageBodyToJson(this);
}

@JsonSerializable()
class MessageBodyInit extends MessageBody {
  @JsonKey(name: "node_id")
  String ownId;
  @JsonKey(name: "node_ids")
  List<String> nodeIds;

  MessageBodyInit({
    required this.ownId,
    required this.nodeIds,
  }) : super(type: "init");
  @override
  Map<String, dynamic> toJson() => _$MessageBodyInitToJson(this);
}

@JsonSerializable()
class MessageBodyEcho extends MessageBody {
  String echo;

  MessageBodyEcho({
    required this.echo,
  }) : super(type: 'echo');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyEchoToJson(this);
}

@JsonSerializable()
class MessageBodyError extends MessageBody {
  MaelstromErrorCode code;
  String text;

  MessageBodyError({required this.code, this.text = ""}) : super(type: 'error');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyErrorToJson(this);
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
}

@JsonSerializable()
class MessageBodyReadOk extends MessageBody {
  List<int> messages;

  MessageBodyReadOk({required this.messages}) : super(type: 'read_ok');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyReadOkToJson(this);
}

@JsonSerializable()
class MessageBodyTopology extends MessageBody {
  Map<String, List<String>> topology;

  MessageBodyTopology({required this.topology}) : super(type: 'topology');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyTopologyToJson(this);
}
