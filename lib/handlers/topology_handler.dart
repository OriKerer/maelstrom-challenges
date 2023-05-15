import 'package:maelstrom_dart/topology.dart';

import 'handler_base.dart';

class TopologyHandler extends HandlerBase<MessageBodyTopology, MessageBody> {
  final Topology _topology;

  TopologyHandler(this._topology);
  @override
  Future<MessageBody> handle(
      RequestContext context, MessageBodyTopology message) async {
    _topology.initialize(message.topology, context.id);
    return MessageBody(
        type: 'topology_ok', id: message.id, inReplyTo: message.id);
  }

  @override
  MessageBodyTopology Function(Map<String, dynamic>) get fromJson =>
      MessageBodyTopology.fromJson;
}
