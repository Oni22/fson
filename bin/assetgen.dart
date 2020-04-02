
import 'package:fson/src/fson_core.dart';
import 'package:fson/src/fson_schema.dart';
import 'package:fson/src/r_asset.dart';

void main(List<String> args) async {
  FSON().buildResource(FSONSchema(
    requiredKeys: ["path"]
  ),
  "images",
  "RAssets",
  RAsset()
  );

}