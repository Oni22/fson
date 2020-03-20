import 'package:string_res/src/fson_base.dart';
import 'package:string_res/string_res.dart';

class RColor extends FSONBase{

  RColor({
    map,
    name
  }) : super(map: map,name: name);

  String dayColor;
  String nightColor;
  int get color => RConfig.isDarkMode ? _hexToInt(nightColor) : _hexToInt(dayColor);

  int _hexToInt(String hex) {
    var hexColor = hex.toUpperCase().replaceAll("#","");
    if(hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor,radix: 16);
  }
}