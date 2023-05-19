class Store {
  final Map<String, int> _data = {};
  List<int> get data => _data.values.toList();
  void add(String id, int val) => _data[id] = val;
  bool exists(String id) => _data.containsKey(id);
}
