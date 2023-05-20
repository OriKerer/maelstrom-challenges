import 'package:maelstrom_dart/handlers/handler_base.dart';
import 'package:maelstrom_dart/log.dart';
import 'package:maelstrom_dart/rpc_client.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';
import 'package:maelstrom_dart/store.dart';

class Gossip {
  final Duration interval;
  final int spreadCount;
  bool gossip = true;
  Gossip(this.interval, this.spreadCount);

  Future start() async {
    while (gossip) {
      // Get the nodes with the most outdated clocks
      var clocks = node.clock.sortedClocksMin;
      for (var i = 0; i < spreadCount; i++) {
        // get store into shape
        Map<String, List<StoreValue>> storeValues = {};
        for (var e in store.data.where((e) => e.clock > clocks[i].value)) {
          storeValues[e.originNode] ??= List<StoreValue>.empty();
          storeValues[e.originNode]!.add(e);
        }

        var message = MessageBodyGossip(
            clock: node.clock.vector, storeValues: storeValues);

        rpcClient
            .sendRPC<MessageBodyGossip>(clocks[i].key, message)
            .then((message) => handleGossipResponse(message, clocks[i].key))
            .onError((error, stack) => log('$error: $stack'));
      }
    }
  }

  void handleGossipResponse(MessageBodyGossip message, String nodeId) {
    var clock = message.clock!;
  }
}
