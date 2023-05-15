import 'package:maelstrom_dart/handlers/broadcast_handler.dart';
import 'package:maelstrom_dart/handlers/generate_handler.dart';
import 'package:maelstrom_dart/handlers/read_handler.dart';
import 'package:maelstrom_dart/handlers/topology_handler.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';
import 'package:maelstrom_dart/handlers/echo_handler.dart';
import 'package:maelstrom_dart/store.dart';

void main(List<String> arguments) {
  var store = Store();
  var n = MaelstromNode();
  n.registerHandler('echo', EchoHandler());
  n.registerHandler('generate', GenerateHandler());
  n.registerHandler('broadcast', BroadcastHandler(store));
  n.registerHandler('read', ReadHandler(store));
  n.registerHandler('topology', TopologyHandler());

  n.run();
}
