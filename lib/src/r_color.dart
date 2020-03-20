import 'package:string_res/src/fson_base.dart';
import 'package:string_res/string_res.dart';

class RColor extends FSONBase{

  RColor({
    map,
    name
  }) : super(map: map,name: name);

  String dayColor;
  String nightColor;
  String get color => RConfig.isDarkMode ? nightColor : dayColor;
}