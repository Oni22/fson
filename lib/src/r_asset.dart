
import 'package:fson/src/fson_base.dart';

class RAsset extends FSONBase {
  RAsset({map,name}) : super(map: map, name: name);

  String get path => getKey("path");

}