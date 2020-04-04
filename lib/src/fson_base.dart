
class FSONBase {
  FSONBase({
    this.map,
    this.name,
  });
  String name;
  String namespace;
  Map<String,dynamic> map = {};

  dynamic getKey(String key) => map[key];
}