
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:string_res/src/fr_parser.dart';

main(List<String> args) {

  var relativePath = path.relative("lib/strings/");
  var dir = Directory(relativePath);
  
  dir.list().forEach((f) async {
    var file = File(f.path);
    var content = await file.readAsString();
    var frParser = FRParser.toRStrings(content);

    String finalContent = "import 'package:string_res/string_res.dart';\nclass R {\n";

    frParser.strings.forEach((r) {
      finalContent += "\tstatic RString ${r.name} = RString(langs: ${r.langs.toString()} ,name: \"${r.name}\");\n";
    });

    finalContent += "}";
    File(relativePath + "/${path.basename(file.path)}.dart").writeAsString(finalContent);
  });

  

}