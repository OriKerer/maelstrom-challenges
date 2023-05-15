import 'dart:collection';

class Topology {
  late Map<String, List<String>> _topology;
  late List<String> _neighbors;
  UnmodifiableListView<String> get neighbors =>
      UnmodifiableListView(_neighbors);
  void initialize(Map<String, List<String>> topology, String ownId) {
    _topology = topology;
    _neighbors = _topology[ownId]!;
  }
}
