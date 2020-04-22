import 'package:fson_parser/fson_parser.dart';
import 'package:fson/fson.dart';

class RColor extends FSONBase{

  RColor({
    map,
    name
  }) : super(map: map,name: name);

  int get day => _hexToInt(getKey("day"));
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