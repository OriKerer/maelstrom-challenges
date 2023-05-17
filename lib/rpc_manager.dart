import 'dart:async';
import 'dart:io';

import 'package:maelstrom_dart/handlers/handler_base.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';

class RPCManager {
  final MaelstromNode _node;
  final Map<int, PendingRPC> _pendingRequests = {};

  RPCManager(this._node);

  Future<void> sendRPC(
      MessageBody message, String dest, HandlerBase? handler) async {
    var timeout = Duration(seconds: 1);
    _pendingRequests[message.id!] = PendingRPC(handler);

    while (_pendingRequests.containsKey(message.id!)) {
      var c = _pendingRequests[message.id!]!.completer = Completer();
      _node.send(dest, message);

      var t = Timer(
        timeout,
        () {
          if (!c.isCompleted) c.complete();
        },
      );
      await c.future;
      t.cancel();
      timeout += timeout;
    }
  }

  HandlerBase? getReplyHandler(int inReplyTo, String type) {
    var res = _pendingRequests.remove(inReplyTo);
    if (res == null) {
      stderr.writeln('Got reply to a non existing request: $type($inReplyTo)');
    }
    res?.complete();
    return res?.handler;
  }
}

class PendingRPC {
  final HandlerBase? handler;
  late Completer<void> completer = Completer();

  void complete() {
    if (!completer.isCompleted) {
      completer.complete();
    }
  }

  PendingRPC(this.handler);
}
