import 'package:string_res/src/fson_base.dart';

class RStyle extends FSONBase {

  RStyle({
    map,
    name
  }) : super(map: map,name: name);

  double get fontSize => double.parse(map["textSize"]);
  String get fontFamily => map["fontFamily"];
  int get fontColor => _hexToInt(map["textColor"]);
  int get backgroundColor => _hexToInt(map["backgroundColor"]);
  String get debugLabel => map["debugLabel"];


  int _hexToInt(String hex) {
    var hexColor = hex.toUpperCase().replaceAll("#","");
    if(hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor,radix: 16);
  }

}