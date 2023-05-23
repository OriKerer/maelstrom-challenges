import 'dart:math';
import 'package:maelstrom_dart/maelstrom_node.dart';

abstract class VectorClockInterface {
  Map<String, int> get vector;
  List<MapEntry<String, int>> get sortedBySmallestClock;
  // bool operator >(VectorClockInterface other);
  // bool operator <(VectorClockInterface other);
  void tick();
}

class VectorClock extends VectorClockInterface {
  final Map<String, int> _vector;
  VectorClock({required Map<String, int> vector}) : _vector = vector;

  void updateFrom(VectorClock other) {
    for (var e in other.vector.entries) {
      vector.update(e.key, (value) => max(value, e.value),
          ifAbsent: () => e.value);
    }
    vector[node.id] = vector.values.reduce(max);
  }

  @override
  int tick() => vector[node.id] = vector[node.id]! + 1;

  @override
  List<MapEntry<String, int>> get sortedBySmallestClock {
    var entries = vector.entries.where((e) => e.key != node.id).toList();
    entries.sort((a, b) => a.value - b.value);
    return entries;
  }

  @override
  Map<String, int> get vector => _vector;
}
