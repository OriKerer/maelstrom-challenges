import 'package:maelstrom_dart/gossip.dart';
import 'package:maelstrom_dart/handlers/add_handler.dart';
import 'package:maelstrom_dart/handlers/adhoc_handler.dart';
import 'package:maelstrom_dart/handlers/error_handler.dart';
import 'package:maelstrom_dart/handlers/generate_handler.dart';
import 'package:maelstrom_dart/handlers/read_handler.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';
import 'package:maelstrom_dart/handlers/echo_handler.dart';
import 'package:maelstrom_dart/messages.dart';
import 'package:maelstrom_dart/store.dart';

void main(List<String> arguments) async {
  var broadcastStore = Store<dynamic>();
  var gossip = Gossip(Duration(milliseconds: 1000), 1, broadcastStore,
      timeout: Duration(milliseconds: 100));
  node.registerHandler('echo', EchoHandler());
  node.registerHandler('error', ErrorHandler());
  node.registerHandler('generate', GenerateHandler());
  // node.registerHandler('broadcast', BroadcastHandler(broadcastStore));
  // node.registerHandler('read', ReadHandlerChallenge3(broadcastStore));
  node.registerHandler('read', ReadHandler(broadcastStore));
  node.registerHandler('add', AddHandler(broadcastStore));
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
