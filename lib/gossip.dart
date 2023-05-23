import 'dart:math';

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
  final Store _store;
  late final AdHocHandler<MessageBodyGossip, MessageBody> gossipBackHandler;

  late final AdHocHandler<MessageBody, MessageBodyGossip> gossipInitiateHandler;

  Gossip(
    this.interval,
    this.spreadCount,
    this._store,
  ) {
    gossipInitiateHandler = AdHocHandler((c, m) async {
      var otherVClock = VectorClock(vector: m.vclock!);
      return MessageBodyGossip(
          vclock: _store.ownVClock.vector,
          storeValues: _store.getNewerThanVClock(otherVClock),
          type: 'gossip');
    });

    gossipBackHandler = AdHocHandler((c, m) async {
      _store.mergeFrom(Store<dynamic>(
          data: m.storeValues, vclock: VectorClock(vector: m.vclock!)));
      return null;
    });
  }

  Future<void> start() async {
    await Future.delayed(Duration(milliseconds: Random().nextInt(500)));
    while (true) {
      await Future.delayed(interval);
      _store.writePendingValues();

      // Get the nodes with the most outdated clocks
      var vclockMin = _store.ownVClock.sortedBySmallestClock;
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
        vclockMin[addressNodeIndex].value == _store.ownVClock.vector[node.id]) {
      return;
    }

    var message =
        MessageBody(vclock: _store.ownVClock.vector, type: 'gossip_initiate');
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
    _store.mergeFrom(Store<dynamic>(
        data: message.storeValues,
        vclock: VectorClock(vector: message.vclock!)));
    rpcClient.send(
        srcNode,
        MessageBodyGossip(
            storeValues:
                _store.getNewerThanVClock(VectorClock(vector: message.vclock!)),
            type: 'gossip_back',
            vclock: _store.ownVClock.vector));
  }
}
