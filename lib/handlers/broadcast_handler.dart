import 'package:maelstrom_dart/rpc_client.dart';

import 'handler_base.dart';
import 'package:maelstrom_dart/store.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';

class BroadcastHandler extends HandlerBase<MessageBodyBroadcast, MessageBody> {
  final Store _store;

  BroadcastHandler(this._store);
  @override
  Future<MessageBody> handle(
      RequestContext context, MessageBodyBroadcast message) async {
    if (message.valueId == null) {
      var uuid = context.uuid.generate();
      _store.add(uuid, message.message);
      message.valueId = uuid;
      for (var node in node.topology.neighbors) {
        rpcClient.sendRPC(node, message);
      }
    } else if (!_store.exists(message.valueId!)) {
      _store.add(message.valueId!, message.message);
      for (var node in node.topology.neighbors.where((e) => e != context.src)) {
        rpcClient.sendRPC(node, message);
      }
    }
    return MessageBody(
      type: "broadcast_ok",
    );
  }
}
