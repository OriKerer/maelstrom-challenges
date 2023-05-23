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
  final gossipBackHandler =
      AdHocHandler<MessageBodyGossip, MessageBody>((c, m) async {
    broadcastStore.mergeFrom(Store<dynamic>(
        data: m.storeValues, vclock: VectorClock(vector: m.vclock!)));
    return null;
  });

  final gossipInitiateHandler =
      AdHocHandler<MessageBody, MessageBodyGossip>((c, m) async {
    var otherVClock = VectorClock(vector: m.vclock!);

    return MessageBodyGossip(
        vclock: broadcastStore.ownVClock.vector,
        storeValues: broadcastStore.getNewerThanVClock(otherVClock),
        type: 'gossip');
  });
  Gossip(this.interval, this.spreadCount);

  Future<void> start() async {
    while (true) {
      await Future.delayed(interval);
      broadcastStore.writePendingValues();

      // Get the nodes with the most outdated clocks
      var vclockMin = broadcastStore.ownVClock.sortedBySmallestClock;
      List<Future<void>> futures = [];
      for (var i = 0; i < spreadCount; i++) {
        futures.add(_sendGossip(vclockMin, i));
      }
      await Future.wait(futures);
    }
  }

  Future<void> _sendGossip(
      List<MapEntry<String, int>> vclockMin, int addressNodeIndex) async {
    if (addressNodeIndex >= vclockMin.length ||
        vclockMin[addressNodeIndex].value ==
            broadcastStore.ownVClock.vector[node.id]) {
      return;
    }

    var message = MessageBody(
        vclock: broadcastStore.ownVClock.vector, type: 'gossip_initiate');
    var destNode = vclockMin[addressNodeIndex].key;
    try {
      var response =
          await rpcClient.sendRPC<MessageBodyGossip>(destNode, message);
      _handleGossipResponse(response, destNode);
    } catch (e, s) {
      log('Gossip timeout: $e: $s');
      await _sendGossip(vclockMin, addressNodeIndex + spreadCount);
    }
  }

  void _handleGossipResponse(MessageBodyGossip message, String srcNode) {
    broadcastStore.mergeFrom(Store<dynamic>(
        data: message.storeValues,
        vclock: VectorClock(vector: message.vclock!)));
    rpcClient.send(
        srcNode,
        MessageBodyGossip(
            storeValues: broadcastStore
                .getNewerThanVClock(VectorClock(vector: message.vclock!)),
            type: 'gossip_back',
            vclock: broadcastStore.ownVClock.vector));
    // HAS TO DO WITH VECTOR CLOCK UPDATE IN NODE
  }
}
