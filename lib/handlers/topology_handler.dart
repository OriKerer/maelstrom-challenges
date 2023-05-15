import 'handler_base.dart';

class TopologyHandler extends HandlerBase<MessageBodyTopology, MessageBody> {
  @override
  Future<MessageBody> handle(
      RequestContext context, MessageBodyTopology message) async {
    return MessageBody(
        type: 'topology_ok', id: message.id, inReplyTo: message.id);
  }

  @override
  MessageBodyTopology Function(Map<String, dynamic>) get fromJson =>
      MessageBodyTopology.fromJson;
}
