import 'dart:collection';

import 'package:maelstrom_dart/handlers/rpc_handler_base.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';

class RequestContext {
  final MaelstromNode _node;
  final String id;
  final String src;
  UnmodifiableListView<String> otherNodes;
  bool _requestAlreadyReplied = false;

  bool get requestAlreadyReplied => _requestAlreadyReplied;

  RequestContext(this._node, this.id, this.otherNodes, this.src);

  void send(String destination, MessageBody message) {
    if (_requestAlreadyReplied == true) {
      throw Exception(
          'Message ${message.id} from $src already been replied to');
    }
    _requestAlreadyReplied = true;
    _node.send(destination, message);
  }
}
