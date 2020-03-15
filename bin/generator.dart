
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:string_res/src/fr_parser.dart';

main(List<String> args) async{

  var relativePath = path.relative("lib/strings/");
  var dir = Directory(relativePath);
  var parseContent = "";
  var files = dir.listSync();

  for(var fileEntity in files) {
    if(path.extension(fileEntity.path) == ".fson") {
      var file = File(fileEntity.path);
      var content = await file.readAsString();
      parseContent += content.replaceAll("\n", "").trim() + ",";
    }
  }
  
  var parser = FRParser();
  await parser.buildLangList();
  String finalContent = "import 'package:string_res/string_res.dart';\nclass R {\n";
  parser.toRStrings(parseContent).forEach((r) {
    finalContent += "\tstatic RString ${r.name} = RString(langs: ${r.langs.toString()} ,name: \"${r.name}\");\n";
  });
  finalContent += "}";
  File(relativePath + "/main.fson.dart").writeAsString(finalContent);
}