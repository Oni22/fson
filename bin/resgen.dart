

import 'dart:io';
import 'package:path/path.dart' as path;


class ResGen {

  void add(String className, String name, String pathToImport) async {

    var relativePath = path.relative("lib/res/");
    var dir = Directory(relativePath).listSync();
    
    if(dir.any((file) => path.basename(file.path) == "r.fson.dart")) {

      var file = await File(relativePath + "/r.fson.dart").readAsString();
      var body = file.replaceFirst("}", "").split("{");

      //var path = "import \"package:\""
      
      var listOfAttrs = body.map((line) {

        var splittedLine = line.split(" ");
        var className = splittedLine[1];
        var fieldName = splittedLine[2];
        return {"type": className, "field": fieldName};

      }).toList();

      listOfAttrs.add({"type": className, "field": name});

      var finalContent = "import $pathToImport;\n class R{\n";
      listOfAttrs.forEach((o) {
        finalContent += "\tstatic ${o["type"]} ${o["field"]} = ${o["type"]}()\n";
      });
      finalContent += "}";
      await File(relativePath + "/r.fson.dart").writeAsString(finalContent);
    } else {
      var finalContent = "import $pathToImport;\n R{\n";
      finalContent += "\tstatic $className $name = $className()\n";
      finalContent += "}";
      await File(relativePath + "/r.fson.dart").writeAsString(finalContent);
    }

  }

}