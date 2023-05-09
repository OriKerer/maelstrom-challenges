import 'package:json_annotation/json_annotation.dart';

enum MaelstromErrorCode {
  @JsonValue(0)
  timeout,
  @JsonValue(1)
  nodeNotFound,
  @JsonValue(10)
  notSupported,
  @JsonValue(11)
  temporarilyUnavailable,
  @JsonValue(12)
  malformedRequest,
  @JsonValue(13)
  crash,
  @JsonValue(14)
  abort,
  @JsonValue(20)
  keyDoesNotExist,
  @JsonValue(21)
  keyAlreadyExist,
  @JsonValue(22)
  preconditionFailed,
  @JsonValue(30)
  txnConflict;
}

class MaelstromException implements Exception {
  final MaelstromErrorCode code;
  final String? description;
  MaelstromException({required this.code, this.description});
  @override
  String toString() => 'Code: $code, description: $description';
}
