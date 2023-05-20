import 'dart:io';
import 'dart:math';

import 'package:maelstrom_dart/maelstrom_node.dart';

class VectorClock {
  final Map<String, int> _vector = {};
  Map<String, int> get vector => _vector;
  void updateFrom(Map<String, int> vector) {
    for (var e in vector.entries) {
      _vector.update(e.key, (value) => max(value, e.value),
          ifAbsent: () => e.value);
    }
  }

  List<MapEntry<String, int>> get sortedClocksMin {
    var entries = vector.entries.where((e) => e.key != node.id).toList();
    entries.sort((a, b) => a.value - b.value);
    stderr.writeln('!@#$entries');
    return entries;
  }
}
