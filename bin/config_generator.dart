
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:string_res/src/fson_core.dart';

main(List<String> args) async{

    var relativePath = path.relative("lib/strings/");
    var files = Directory(relativePath).listSync();
    var hasConfigFile = files.firstWhere((file) => path.basename(file.path) == "config.fson") != null;

    if(hasConfigFile) {
      var finalContent = "class RConfig {\n";
      var content = await File(relativePath + "/config.fson").readAsString();
      FSON().parse(content).forEach((fson) {
        if(fson.name == "string_config") {
          var backUpLanguage = fson.keyValueNodes.firstWhere((l) => l.key == "backUpLanguage",orElse: () => null);
          if(backUpLanguage != null) {
            finalContent += "\tstatic String backUpLanguage = ${backUpLanguage.value};\n";
          }
          var langs = fson.keyValueNodes.firstWhere((l) => l.key == "languageCodes",orElse: () => null);
          if(langs != null) {
            finalContent += "\tstatic List<String> languageCodes = ${langs.arrayList};\n";
          }
        }
      });

      finalContent += "}";
      File(relativePath + "/config.fson.dart").writeAsString(finalContent);

    } else {
      throw FileSystemException("FSON_ERROR: Could not found config.fson. Please add the file under the lib/strings folder!");
    }
}