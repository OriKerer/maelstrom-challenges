import 'package:maelstrom_dart/handlers/adhoc_handler.dart';
import 'package:maelstrom_dart/handlers/handler_base.dart';
import 'package:maelstrom_dart/log.dart';
import 'package:maelstrom_dart/rpc_client.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';
import 'package:maelstrom_dart/store.dart';
import 'package:maelstrom_dart/vector_clock.dart';

class Gossip {
  final Duration interval;
  final int spreadCount;
  final bool _gossip = true;
  final gossipBackHandler =
      AdHocHandler<MessageBodyGossip, MessageBody>((c, m) async {
    broadcastStore.mergeFrom(m.storeValues);
    node.vclock.updateFrom(VectorClock(vector: m.vclock!));
    return null;
  });

  final gossipInitiateHandler =
      AdHocHandler<MessageBody, MessageBodyGossip>((c, m) async {
    var otherVClock = VectorClock(vector: m.vclock!);

    return MessageBodyGossip(
        vclock: node.vclock.vector,
        storeValues: broadcastStore.getNewerThanVClock(otherVClock),
        type: 'gossip');
  });
  Gossip(this.interval, this.spreadCount);

  Future start() async {
    while (_gossip) {
      await Future.delayed(interval);

      // Get the nodes with the most outdated clocks
      var vclockMin = node.vclock.sortedBySmallestClock;

      for (var i = 0; i < spreadCount; i++) {
        _sendGossip(vclockMin, i);
      }
    }
  }

  void _sendGossip(
      List<MapEntry<String, int>> vclockMin, int addressNodeIndex) {
    if (addressNodeIndex >= vclockMin.length ||
        vclockMin[addressNodeIndex].value == node.vclock.vector[node.id]) {
      return;
    }

    var message =
        MessageBody(vclock: node.vclock.vector, type: 'gossip_initiate');

    rpcClient
        .sendRPC<MessageBodyGossip>(vclockMin[addressNodeIndex].key, message)
        .then(
          (message) =>
              _handleGossipResponse(message, vclockMin[addressNodeIndex].key),
        )
        .onError((error, stack) {
      log('Gossip timeout: $error: $stack');

      _sendGossip(vclockMin, addressNodeIndex + spreadCount);
    });
  }

  void _handleGossipResponse(MessageBodyGossip message, String srcNode) {
    broadcastStore.mergeFrom(message.storeValues);
    node.vclock.updateFrom(VectorClock(vector: message.vclock!));
    rpcClient.send(
        srcNode,
        MessageBodyGossip(
            storeValues: broadcastStore
                .getNewerThanVClock(VectorClock(vector: message.vclock!)),
            type: 'gossip_back',
            vclock: node.vclock.vector));
    // HAS TO DO WITH VECTOR CLOCK UPDATE IN NODE
  }
}
