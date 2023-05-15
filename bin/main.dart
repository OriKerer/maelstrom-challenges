import 'package:maelstrom_dart/handlers/broadcast_handler.dart';
import 'package:maelstrom_dart/handlers/generate_handler.dart';
import 'package:maelstrom_dart/handlers/read_handler.dart';
import 'package:maelstrom_dart/handlers/topology_handler.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';
import 'package:maelstrom_dart/handlers/echo_handler.dart';
import 'package:maelstrom_dart/store.dart';
import 'package:maelstrom_dart/topology.dart';

void main(List<String> arguments) {
  var store = Store();
  var topology = Topology();
  var n = MaelstromNode();
  n.registerHandler('echo', EchoHandler());
  n.registerHandler('generate', GenerateHandler());
  n.registerHandler('broadcast', BroadcastHandler(store, topology));
  n.registerHandler('read', ReadHandler(store));
  n.registerHandler('topology', TopologyHandler(topology));

  n.run();
}
