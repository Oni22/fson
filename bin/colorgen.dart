import 'package:string_res/src/fson_core.dart';
import 'package:string_res/src/fson_schema.dart';
import 'package:string_res/src/r_color.dart';


main(List<String> args) async{
  FSON().buildResource(FSONSchema(
    fsonCustomValidate: (fson) {
      if(fson.keyValueNodes.any((kv) => (kv?.arrayList?.length ?? 0) > 0) == true) {
        throw FormatException("The colors namespace doesn't support arrays!");
      }
    },
    requiredKeys: ["day"],
    keys: ["day","night"]
  ),
  "colors",
  "RColors",
  RColor()
  );
}