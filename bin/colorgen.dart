import 'package:string_res/src/fson_core.dart';
import 'package:string_res/src/fson_schema.dart';
import 'package:string_res/src/r_color.dart';


main(List<String> args) async{
  FSON().buildResource(FSONSchema(
    requiredKeys: ["day"],
    keys: ["day","night"]
  ),
  "lib/colors/",
  "colors.fson.dart",
  "C",
  RColor()
  );
}