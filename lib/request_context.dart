import 'dart:convert';
import 'dart:io';

import 'package:maelstrom_dart/handlers/handler_base.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';
import 'package:maelstrom_dart/uuid.dart';

enum SourceType {
  client,
  node;
}

class RequestContext {
  final MaelstromNode _node;
  final String src;
  static int _idCounter = 0;

  String get ownId => _node.id;
  List<String> get cluster => _node.cluster;
  List<String> get neighboringNodes => _node.topology.neighbors;
  SourceType get sourceType =>
      src.startsWith('n') ? SourceType.node : SourceType.client;
  UUID get uuid => _node.uuid;

  RequestContext(this._node, this.src);

  int generateMessageId() => _idCounter++;

  List<String> getNeighborsOf(String id) => _node.topology.getNeighborsOf(id);

  List<String> getNeighborsDifferenceFrom(String id) =>
      _node.topology.getNeighborsDifferenceFrom(id);

  void send(String dest, MessageBody body, {int? inReplyTo, int? messageId}) {
    var bodyMap = body.toJson();
    bodyMap['msg_id'] = messageId ?? generateMessageId();
    bodyMap['in_reply_to'] = inReplyTo;
    var fullJson = jsonEncode({
      'src': ownId,
      'dest': dest,
      'body': bodyMap,
    });
    stdout.nonBlocking.writeln(fullJson);
    // stderr.writeln('@@@ [${DateTime.now()}] $fullJson');
  }

  Future<void> sendRPC(
    MessageBody message,
    String dest, {
    HandlerBase? handler,
    int maxReties = 1,
  }) =>
      _node.rpcManager
          .sendRPC(this, message, dest, handler: handler, maxReties: maxReties);
}
