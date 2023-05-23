import 'dart:collection';

import 'package:maelstrom_dart/error.dart';
import 'package:maelstrom_dart/vector_clock.dart';

typedef StoreData<T> = Map<String, Map<int, T>>;

class Store<T> {
  // final List<StoreValue> _data = [];
  final StoreData<T> data;
  final pendingWrites = Queue<StoreValue<T>>();
  final VectorClock ownVClock;

  Store({StoreData<T>? data, VectorClock? clock})
      : data = data ?? {},
        ownVClock = clock ?? VectorClock(vector: {});
  // List<int> get dataList =>
  //     _data.values.reduce((v, e) => v + e).map((e) => e.value).toList();

  void writePendingValues() {
    while (pendingWrites.isNotEmpty) {
      var val = pendingWrites.removeFirst();
      data[val.originNode] ??= {};
      if (data[val.originNode]!.containsKey(val.clock)) {
        throw MaelstromException(
            desc:
                'Store already contain value for (${val.originNode},${val.clock})');
      }
      data[val.originNode]![val.clock] = val.value;
      ownVClock.tick();
    }
  }

  void add(int clock, T val, String originNode) {
    pendingWrites.add(StoreValue(clock, val, originNode));
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

  // StoreData<T> getNewerThanClock(int clock) {
  //   var newValues = StoreData<T>.from({});
  //   for (var n in data.entries) {
  //     var newEntries = n.value.entries.where((e) => e.key > clock);
  //     newValues[n.key] = Map<int, T>.fromEntries(newEntries);
  //   }
  //   return newValues;
  // }

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

final broadcastStore = Store<dynamic>();

class StoreValue<T> {
  final int clock;
  final T value;
  final String originNode;

  StoreValue(this.clock, this.value, this.originNode);
}
