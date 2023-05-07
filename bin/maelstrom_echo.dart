import 'package:maelstrom_echo/node.dart';
import 'package:maelstrom_echo/handlers/echo_handler.dart';

void main(List<String> arguments) {
  var n = Node();
  n.registerHandler('echo', EchoHandler());
  n.run();
}
