import 'dart:io';

import 'package:maelstrom_dart/maelstrom_node.dart';
import 'package:maelstrom_dart/store.dart';

void log(String toLog) {
  stderr.nonBlocking
      .writeln('[${node.vclock.vector} | ${DateTime.now()}] $toLog');
}
