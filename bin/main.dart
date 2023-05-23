import 'package:maelstrom_dart/gossip.dart';
import 'package:maelstrom_dart/handlers/adhoc_handler.dart';
import 'package:maelstrom_dart/handlers/broadcast_handler.dart';
import 'package:maelstrom_dart/handlers/error_handler.dart';
import 'package:maelstrom_dart/handlers/generate_handler.dart';
import 'package:maelstrom_dart/handlers/read_handler.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';
import 'package:maelstrom_dart/handlers/echo_handler.dart';
import 'package:maelstrom_dart/messages.dart';

void main(List<String> arguments) async {
  var gossip = Gossip(Duration(milliseconds: 200), 3);
  node.registerHandler('echo', EchoHandler());
  node.registerHandler('error', ErrorHandler());
  node.registerHandler('generate', GenerateHandler());
  node.registerHandler('broadcast', BroadcastHandler());
  node.registerHandler('read', ReadHandler());
  node.registerHandler('gossip_initiate', gossip.gossipInitiateHandler);
  node.registerHandler('gossip_back', gossip.gossipBackHandler);
  node.registerHandler('topology',
      AdHocHandler<MessageBodyTopology, MessageBody>((context, message) async {
    return MessageBody(
      type: 'topology_ok',
    );
  }));
  gossip.start();
  node.run();
}
