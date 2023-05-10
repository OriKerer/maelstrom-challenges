import 'package:maelstrom_dart/handlers/generate_handler.dart';
import 'package:maelstrom_dart/node.dart';
import 'package:maelstrom_dart/handlers/echo_handler.dart';

void main(List<String> arguments) {
  var n = Node();
  n.registerHandler('echo', EchoHandler());
  n.registerHandler('generate', GenerateHandler(n));
  n.run();
}
