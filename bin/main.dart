import 'package:maelstrom_dart/handlers/broadcast_handler.dart';
import 'package:maelstrom_dart/handlers/error_handler.dart';
import 'package:maelstrom_dart/handlers/generate_handler.dart';
import 'package:maelstrom_dart/handlers/read_handler.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';
import 'package:maelstrom_dart/handlers/echo_handler.dart';
import 'package:maelstrom_dart/store.dart';

void main(List<String> arguments) async {
  var store = Store();
  node.registerHandler('echo', EchoHandler());
  node.registerHandler('error', ErrorHandler());
  node.registerHandler('generate', GenerateHandler());
  node.registerHandler('broadcast', BroadcastHandler(store));
  node.registerHandler('read', ReadHandler(store));

  node.run();
}
