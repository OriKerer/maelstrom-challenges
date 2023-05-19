import 'dart:math';

class UUID {
  final Random _rand = Random();
  final String _ownId;
  UUID(String ownId) : _ownId = ownId.toString().substring(1);

  String generate() {
    var t =
        DateTime.now().millisecondsSinceEpoch.toRadixString(36); // timestamp
    var r = _rand.nextInt(pow(36, 4).toInt()).toRadixString(36); // random
    return '$_ownId$t$r';
  }
}
