

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:string_res/src/fr_parser.dart';

main(List<String> args) async {

  var relativePath = path.relative("lib/src/strings/");
  var content = await File(relativePath + "/lang.fson").readAsString();
  var frParser = FRParser.toRStrings(content);
  
  String finalContent = "import 'package:string_res/string_res.dart';\nclass R {\n";

  frParser.strings.forEach((r) {
    finalContent += "\tstatic RString ${r.name} = RString(langs: ${r.langs.toString()} ,name: \"${r.name}\");\n";
  });
  
  finalContent += "}";
  File(relativePath + "/lang.fson.dart").writeAsString(finalContent);

}