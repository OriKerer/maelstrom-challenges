import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:maelstrom_dart/handlers/adhoc_handler.dart';
import 'package:maelstrom_dart/handlers/handler_base.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';

class RPCClient {
  final Map<int, HandlerBase> _pendingRequests = {};
  static int _idCounter = 0;

  int generateMessageId() => _idCounter++;

  void send(String dest, MessageBody body, {int? inReplyTo, int? messageId}) {
    var bodyMap = body.toJson();
    bodyMap['msg_id'] = messageId ?? generateMessageId();
    if (inReplyTo != null) bodyMap['in_reply_to'] = inReplyTo;
    var fullJson = jsonEncode({
      'src': node.id,
      'dest': dest,
      'body': bodyMap,
    });
    stdout.nonBlocking.writeln(fullJson);
    // stderr.writeln('@@@ [${DateTime.now()}] $fullJson');
  }

  Future<RESPONSE> sendRPC<RESPONSE extends MessageBody>(
    String dest,
    MessageBody message, {
    Duration timeout = const Duration(seconds: 1),
  }) async {
    var messageId = generateMessageId();
    var completer = Completer<RESPONSE>();

    // complete future with response value
    _pendingRequests[messageId] =
        AdHocHandler<RESPONSE, MessageBody>((_, request) async {
      completer.complete(request);
      return null;
    });

    send(dest, message, messageId: messageId);

    // complete future with error if timeout
    var t = Timer(timeout, () {
      if (!completer.isCompleted) {
        completer.completeError('RPC($messageId) timed out');
      }
    });

    var rpcResponse = await completer.future;
    t.cancel();
    return rpcResponse;
  }

  HandlerBase? getPendingRPCHandler(int inReplyTo) =>
      _pendingRequests.remove(inReplyTo);
}

final rpcClient = RPCClient();
