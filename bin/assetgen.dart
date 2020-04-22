import 'package:fson/src/r_asset.dart';
import 'package:fson_parser/fson_parser.dart';

void main(List<String> args) async {
  FSON().buildResource(FSONSchema(
    requiredKeys: ["path"]
  ),
  "images",
  "RAssets",
  RAsset()
  );

}