

class FSONNode {

  FSONNode({
    this.name,
  });

  String name;
  List<FSONKeyValueNode> keyValueNodes = [];
}

class FSONKeyValueNode {
  FSONKeyValueNode({this.key});
  String key;
  String value;
  List<String> arrayList = [];
}