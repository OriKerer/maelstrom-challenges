import 'package:json_annotation/json_annotation.dart';
import 'package:maelstrom_dart/error.dart';
import 'package:maelstrom_dart/store.dart';

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
    'gossip' => _$MessageBodyGossipFromJson,
    'gossip_back' => _$MessageBodyGossipFromJson,
    'add' => _$MessageBodyAddFromJson,
    'send' => _$MessageBodySendFromJson,
    'send_ok' => _$MessageBodySendOkFromJson,
    'poll' => _$MessageBodyPollFromJson,
    'poll_ok' => _$MessageBodyPollOkFromJson,
    'list_committed_offsets' => _$MessageBodyListCommitOffsetsOkFromJson,
    'list_committed_offsets_ok' => _$MessageBodyListCommitOffsetsOkFromJson,
    _ => _$MessageBodyFromJson,
  }(bodyMap);
}

@JsonSerializable()
class MessageBody {
  String type;
  Map<String, int>? vclock;

  MessageBody({required this.type, this.vclock});
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
class MessageBodyReadOkChallenge3 extends MessageBody {
  List<int> messages;

  MessageBodyReadOkChallenge3({required this.messages})
      : super(type: 'read_ok');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyReadOkChallenge3ToJson(this);
}

@JsonSerializable()
class MessageBodyReadOk extends MessageBody {
  int value;

  MessageBodyReadOk({required this.value}) : super(type: 'read_ok');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyReadOkToJson(this);
}

@JsonSerializable()
class MessageBodyAdd extends MessageBody {
  int delta;

  MessageBodyAdd({required this.delta}) : super(type: 'add');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyAddToJson(this);
}

@JsonSerializable()
class MessageBodyTopology extends MessageBody {
  Map<String, List<String>> topology;

  MessageBodyTopology({required this.topology}) : super(type: 'topology');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyTopologyToJson(this);
}

@JsonSerializable()
class MessageBodyGossip extends MessageBody {
  StoreData<dynamic> storeValues;

  MessageBodyGossip(
      {required this.storeValues, required super.vclock, required super.type});
  @override
  Map<String, dynamic> toJson() => _$MessageBodyGossipToJson(this);
}

@JsonSerializable()
class MessageBodySend extends MessageBody {
  int msg;
  String key;

  MessageBodySend({required this.key, required this.msg}) : super(type: 'send');
  @override
  Map<String, dynamic> toJson() => _$MessageBodySendToJson(this);
}

@JsonSerializable()
class MessageBodySendOk extends MessageBody {
  int offset;

  MessageBodySendOk({required this.offset}) : super(type: 'send_ok');
  @override
  Map<String, dynamic> toJson() => _$MessageBodySendOkToJson(this);
}

@JsonSerializable()
class MessageBodyPoll extends MessageBody {
  Map<String, int> offsets;

  MessageBodyPoll({required this.offsets}) : super(type: 'poll');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyPollToJson(this);
}

@JsonSerializable()
class MessageBodyPollOk extends MessageBody {
  Map<String, List<int>> msgs;

  MessageBodyPollOk({required this.msgs}) : super(type: 'poll_ok');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyPollOkToJson(this);
}

@JsonSerializable()
class MessageBodyCommitOffsets extends MessageBody {
  Map<String, int> offsets;

  MessageBodyCommitOffsets({required this.offsets})
      : super(type: 'commit_offsets');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyCommitOffsetsToJson(this);
}

@JsonSerializable()
class MessageBodyListCommitOffsets extends MessageBody {
  List<String> keys;

  MessageBodyListCommitOffsets({required this.keys})
      : super(type: 'list_committed_offsets');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyListCommitOffsetsToJson(this);
}

@JsonSerializable()
class MessageBodyListCommitOffsetsOk extends MessageBody {
  Map<String, int> offsets;

  MessageBodyListCommitOffsetsOk({required this.offsets})
      : super(type: 'list_committed_offsets');
  @override
  Map<String, dynamic> toJson() => _$MessageBodyListCommitOffsetsOkToJson(this);
}
