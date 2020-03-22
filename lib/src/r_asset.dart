
import 'package:string_res/src/fson_base.dart';
import 'package:string_res/src/r_config.dart';

class RAsset extends FSONBase {
  RAsset({map,name}) : super(map: map, name: name);

  String get path => getKey("path");

}