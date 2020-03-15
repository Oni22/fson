
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:string_res/src/fr_parser.dart';

main(List<String> args) {

  var relativePath = path.relative("lib/strings/");
  var dir = Directory(relativePath);
  var parseContent = "";
  
  var files = dir.list();
  files.forEach((f) async {
    var file = File(f.path);
    if(path.extension(path.basename(file.path)) == ".fson") {
      var content = await file.readAsString();
      parseContent += content + ",";
    }
  });

  var frParser = FRParser.toRStrings(parseContent);
    String finalContent = "import 'package:string_res/string_res.dart';\nclass R {\n";
    
    frParser.strings.forEach((r) {
      finalContent += "\tstatic RString ${r.name} = RString(langs: ${r.langs.toString()} ,name: \"${r.name}\");\n";
    });
    
    finalContent += "}";
    
    File(relativePath + "/main.fson.dart").writeAsString(finalContent);
}