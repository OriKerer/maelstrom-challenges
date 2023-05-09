enum MaelstromError {
  timeout(0),
  nodeNotFound(1),
  notSupported(10),
  temporarilyUnavailable(11),
  malformedRequest(12),
  crash(13),
  abort(14),
  keyDoesNotExist(20),
  keyAlreadyExist(21),
  preconditionFailed(22),
  txnConflict(30);

  final int code;
  const MaelstromError(this.code);
}

class MaelstromException implements Exception {
  final MaelstromError code;
  final String? description;
  MaelstromException({required this.code, this.description});
}
