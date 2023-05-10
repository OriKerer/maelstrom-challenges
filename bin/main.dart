import 'package:maelstrom_dart/handlers/generate_handler.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';
import 'package:maelstrom_dart/handlers/echo_handler.dart';

void main(List<String> arguments) {
  var n = MaelstromNode();
  n.registerHandler('echo', EchoHandler());
  n.registerHandler('generate', GenerateHandler());
  n.run();
}
