import 'package:maelstrom_dart/maelstrom_node.dart';
import 'package:maelstrom_dart/uuid.dart';

enum SourceType {
  client,
  node;
}

class RequestContext {
  final String src;

  SourceType get sourceType =>
      src.startsWith('n') ? SourceType.node : SourceType.client;

  UUID get uuid => node.uuid;

  RequestContext(this.src);
}
