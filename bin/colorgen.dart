// import 'package:fson_parser/fson_parser.dart';
// import 'package:fson/src/r_color.dart';


// main(List<String> args) async{
//   build();
// }

// void build() {
//   FSON().buildResource(FSONSchema(
//     fsonCustomValidate: (fson) {
//       if(fson.keyValueNodes.any((kv) => (kv?.arrayList?.length ?? 0) > 0) == true) {
//         throw FormatException("The colors namespace doesn't support arrays!");
//       }
//     },
//     requiredKeys: ["day"],
//     keys: ["day","night"]
//   ),
//   "colors",
//   "RColors",
//   RColor()
//   );
// }