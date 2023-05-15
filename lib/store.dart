import 'dart:collection';

class Store {
  final List<int> _data = [];
  UnmodifiableListView<int> get data => UnmodifiableListView(_data);
  void add(int val) => _data.add(val);
}
