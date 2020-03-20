
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:string_res/src/fson_core.dart';

main(List<String> args) async{

  var relativePath = path.relative("lib/strings/");
  var dir = Directory(relativePath);
  var parseContent = "";
  var files = dir.listSync();
  List<String> currentIds =  [];

  for(var fileEntity in files) {
    if(path.extension(fileEntity.path) == ".fson" && path.basename(fileEntity.path) != "config.fson") {
      var file = File(fileEntity.path);
      var content = await file.readAsString();
      parseContent += content.replaceAll("\n", "").trim() + ",";
    }
  }
  
  String finalContent = "import 'package:string_res/string_res.dart';\nclass R {\n";
  var fsons = FSON().parse(parseContent);
  fsons.forEach((fson) {

    if(currentIds.contains(fson.name)) {
      throw FormatException("Id already exists! at id: ${fson.name}");
    } else {
      currentIds.add(fson.name);
    } 

    Map<String,dynamic> langs = {};
    fson.keyValueNodes.forEach((langTextModel) {

      if(langTextModel.arrayList.length > 0) {
        langs["\"${langTextModel.key}\""] = langTextModel.arrayList;
      } 
      else {
        langs["\"${langTextModel.key}\""] = langTextModel.value;
      }

    });
    
    finalContent += "\tstatic RString ${fson.name} = RString(langs: ${langs.toString()} ,name: \"${fson.name}\");\n";

  });

  finalContent += "}";
  File(relativePath + "/main.fson.dart").writeAsString(finalContent);
}