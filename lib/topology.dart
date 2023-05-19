class Topology {
  Map<String, List<String>> _topology = {};
  List<String> _neighbors = [];
  List<String> get neighbors => _neighbors;
  final Map<String, List<String>> _neighborsDifference = {};

  void initialize(Map<String, List<String>> topology, String ownId) {
    _topology = topology;
    _neighbors = _topology[ownId]!;
    for (var k in _topology.keys) {
      _neighborsDifference[k] = _neighbors
          .where((e) => !_topology[k]!.contains(e) && e != k)
          .toList();
    }
  }

  List<String> getNeighborsOf(String id) {
    return _topology[id]!;
  }

  List<String> getNeighborsDifferenceFrom(String id) {
    return _neighborsDifference[id]!;
  }
}
