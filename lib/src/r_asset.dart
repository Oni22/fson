
import 'package:fson_parser/fson_parser.dart';

class RAsset extends FSONBase {
  RAsset({map,name}) : super(map: map, name: name);

  String get path => getKey("path");

}