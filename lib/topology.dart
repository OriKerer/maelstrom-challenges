import 'dart:collection';

class Topology {
  Map<String, List<String>> _topology = {};
  List<String> _neighbors = [];
  UnmodifiableListView<String> get neighbors =>
      UnmodifiableListView(_neighbors);
  void initialize(Map<String, List<String>> topology, String ownId) {
    _topology = topology;
    _neighbors = _topology[ownId]!;
  }
}
