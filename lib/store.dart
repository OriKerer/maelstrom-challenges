import 'package:maelstrom_dart/handlers/handler_base.dart';

class Store {
  final List<StoreValue> _data = [];
  List<StoreValue> get data => _data;
  // List<int> get dataList =>
  //     _data.values.reduce((v, e) => v + e).map((e) => e.value).toList();

  void add(int clock, int val, String originNode) {
    _data.add(StoreValue(clock: clock, value: val, originNode: originNode));
    _data.sort((a, b) => b.clock - a.clock);
  }
}

final store = Store();
