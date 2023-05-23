import 'dart:io';

import 'package:maelstrom_dart/store.dart';

void log(String toLog) {
  stderr.nonBlocking.writeln(
      '[${broadcastStore.ownVClock.vector} | ${DateTime.now()}] $toLog');
}
