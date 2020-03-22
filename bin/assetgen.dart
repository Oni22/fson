
import 'package:string_res/src/fson_core.dart';
import 'package:string_res/src/fson_schema.dart';
import 'package:string_res/src/r_asset.dart';

void main(List<String> args) async {
  FSON().buildResource(FSONSchema(
    requiredKeys: ["path"]
  ),
  "images",
  "RAssets",
  RAsset()
  );

}