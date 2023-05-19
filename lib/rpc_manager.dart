import 'dart:async';

import 'package:maelstrom_dart/handlers/handler_base.dart';

class RPCManager {
  final Map<int, PendingRPC> _pendingRequests = {};

  RPCManager();

  Future<void> sendRPC(
    RequestContext context,
    MessageBody message,
    String dest, {
    HandlerBase? handler,
    int maxReties = 1,
  }) async {
    var timeout = Duration(seconds: 1);
    var messageId = context.generateMessageId();
    _pendingRequests[messageId] = PendingRPC(handler);

    while (_pendingRequests.containsKey(messageId) && maxReties > 0) {
      var c = _pendingRequests[messageId]!.completer = Completer();
      context.send(dest, message, messageId: messageId);
      var t = Timer(timeout, () {
        if (!c.isCompleted) c.complete();
        timeout += timeout;
        maxReties--;
        var newMessageId = context.generateMessageId();
        _pendingRequests[newMessageId] = _pendingRequests.remove(messageId)!;
        messageId = newMessageId;
      });

      await c.future;

      t.cancel();
    }
  }

  PendingRPC? getPendingRPC(int inReplyTo) {
    var res = _pendingRequests.remove(inReplyTo);
    res?.complete();

    return res;
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
