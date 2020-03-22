import 'package:string_res/src/fson_base.dart';
import 'package:string_res/string_res.dart';

class RColor extends FSONBase{

  RColor({
    map,
    name
  }) : super(map: map,name: name);

  int get day => _hexToInt(getKey("night"));
  int get night => _hexToInt(getKey("night"));
  int get color => RConfig.isDarkMode ? night : day;

  int _hexToInt(String hex) {
    var hexColor = hex.toUpperCase().replaceAll("#","");
    if(hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor,radix: 16);
  }
}