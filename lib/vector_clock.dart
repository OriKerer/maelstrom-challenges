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
  void tick() => vector[node.id] = vector[node.id]! + 1;

  @override
  List<MapEntry<String, int>> get sortedBySmallestClock {
    var entries = vector.entries.where((e) => e.key != node.id).toList();
    entries.sort((a, b) => a.value - b.value);
    // log('!@#$entries');
    return entries;
  }

  // @override
  // bool operator >(VectorClockInterface other) {
  //   return other.vector.entries
  //       .every((e) => vector[e.key] != null && vector[e.key]! > e.value);
  // }

  // @override
  // bool operator <(VectorClockInterface other) {
  //   return vector.entries.every(
  //       (e) => other.vector[e.key] != null && other.vector[e.key]! > e.value);
  // }

  @override
  Map<String, int> get vector => _vector;
}
