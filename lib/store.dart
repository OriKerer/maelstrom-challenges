import 'dart:collection';

import 'package:maelstrom_dart/error.dart';
import 'package:maelstrom_dart/maelstrom_node.dart';
import 'package:maelstrom_dart/vector_clock.dart';

typedef StoreData<T> = Map<String, Map<int, T>>;

class Store<T> {
  final StoreData<T> data;
  final _pendingWrites = Queue<T>();
  final VectorClock ownVClock;

  Store({StoreData<T>? data, VectorClock? vclock})
      : data = data ?? {},
        ownVClock = vclock ?? VectorClock(vector: {}) {
    node.initNotificationList.add(() {
      for (var n in node.cluster) {
        ownVClock.vector[n] = 0;
      }
    });
  }

  void writePendingValues() {
    while (_pendingWrites.isNotEmpty) {
      var clock = ownVClock.tick();
      var val = _pendingWrites.removeFirst();
      data[node.id] ??= {};
      if (data[node.id]!.containsKey(clock)) {
        throw MaelstromException(
            desc: 'Store already contain value for (${node.id},$clock)');
      }
      data[node.id]![clock] = val;
    }
  }

  void addPending(T val) {
    _pendingWrites.add(val);
  }

  StoreData<T> getNewerThanVClock(VectorClock vclock) {
    var newValues = StoreData<T>.from({});
    for (var n in data.entries) {
      var newEntries = n.value.entries.where((e) =>
          vclock.vector[n.key] == null ? true : e.key > vclock.vector[n.key]!);
      if (newEntries.isNotEmpty) {
        newValues[n.key] = Map<int, T>.fromEntries(newEntries);
      }
    }
    return newValues;
  }

  void mergeFrom(Store<T> other) {
    for (var n in other.data.entries) {
      data[n.key] ??= {};
      for (var v in n.value.entries) {
        data[n.key]![v.key] ??= v.value;
      }
    }
    ownVClock.updateFrom(other.ownVClock);
  }
}
