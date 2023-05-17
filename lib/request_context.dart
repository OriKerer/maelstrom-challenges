import 'dart:collection';

import 'package:maelstrom_dart/handlers/handler_base.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';

enum SourceType {
  client,
  node;
}

class RequestContext {
  final MaelstromNode _node;
  final String src;
  static int _idCounter = 0;

  String get ownId => _node.id;
  UnmodifiableListView<String> get cluster => _node.cluster;
  UnmodifiableListView<String> get neighboringNodes => _node.topology.neighbors;
  SourceType get sourceType =>
      src.startsWith('n') ? SourceType.node : SourceType.client;

  RequestContext(this._node, this.src);

  int generateMessageId() => _idCounter++;

  void send(String destination, MessageBody message) =>
      _node.send(destination, message);
  Future<void> sendRPC(
          MessageBody message, String dest, HandlerBase? handler) =>
      _node.rpcManager.sendRPC(message, dest, handler);
}
