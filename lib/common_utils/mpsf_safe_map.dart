class MpsfSafeMap {
  MpsfSafeMap(this.value);

  final dynamic value;

  MpsfSafeMap operator [](dynamic key) {
    if (value is Map) return MpsfSafeMap(value[key]);
    if (value is List) {
      List _list = value;
      int max = _list.length - 1;
      if (key is int && key < max) return MpsfSafeMap(value[key]);
    }
    return MpsfSafeMap(null);
  }

  dynamic get v => value;
  String get string => value is String ? value as String : null;
  num get number => value is num ? value as num : null;
  Map get map => value is Map ? value as Map : null;
  List get list => value is List ? value as List : null;
  bool get boolean => value is bool ? value as bool : false;

  bool isEmpty() {
    if (this.v == null) return true;
    if (this.string == '') return true;
    if (this.number == 0) return true;
    if (this.map?.keys?.length == 0) return true;
    if (this.list?.length == 0) return true;
    if (this.boolean == false) return true;
    return false;
  }

  @override
  String toString() => '<SafeMap:$value>';
}
