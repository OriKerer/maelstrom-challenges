import 'package:maelstrom_dart/node.dart';
import 'package:maelstrom_dart/handlers/echo_handler.dart';

void main(List<String> arguments) {
  var n = Node();
  n.registerHandler('echo', EchoHandler());
  n.run();
}
