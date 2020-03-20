import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:string_res/src/fson_base.dart';
import 'package:string_res/src/fson_models.dart';
import 'package:string_res/src/fson_schema.dart';
import 'package:string_res/src/fson_validator.dart';

class FSON {

  List<FSONNode> parse(String frData) {

    List<FSONNode> fsonModels = [];

    var idBlocks = frData.split(RegExp(r"\},"));
    idBlocks.removeWhere((s) => s.length == 0);

    idBlocks.forEach((block) {
      var blockNameLangs = block.split(RegExp(r"\{"));
      var fsonModel = FSONNode(
        name: blockNameLangs[0].trim(),
      );

      var langs = blockNameLangs[1];

      var fsonValidatorId = FSONValidator.validateStringId(fsonModel.name);
      if(!fsonValidatorId.isValid) {
        throw FormatException(fsonValidatorId.message + " " + "at id: ${fsonModel.name}");
      }

      langs.replaceAll("}","").replaceAll("},","").trim().split(RegExp(r"(,)(?![^[]*\])")).forEach((lang) {
        var langCodeText = lang.split(":");
        var langCode = langCodeText[0].trim();
        var text = langCodeText[1].trim();

        var keyValueNode = FSONKeyValueNode(
          key: langCode,
        );

        var fsonValidatorText = FSONValidator.validateText(text);
        if(!fsonValidatorText.isValid) {
          throw FormatException(fsonValidatorText.message + " " + "at id: ${fsonModel.name}");
        }

        if(text.contains(RegExp(r"\[(.*?)\]"))) {
          var plurals = text.replaceAll("[", "").replaceAll("]", "").trim().split(",");
          keyValueNode.arrayList = plurals;
        } else {
          keyValueNode.value = text;
        }

        fsonModel.keyValueNodes.add(keyValueNode);
      });
      fsonModels.add(fsonModel);
    });
    return fsonModels;
  }

  void buildResource(FSONSchema schema,String readFilesFrom, String saveOutputAs, String parentClassName,FSONBase child) async{

    if(child is FSONBase == false) {
      throw Exception("Membertype doens't extend from FSONBase class!");
    }

    var relativePath = path.relative(readFilesFrom);
    var dir = Directory(relativePath);

    if(!dir.existsSync()) { 
      dir.createSync();
    }

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

    String finalContent = "import 'package:string_res/string_res.dart';\nclass $parentClassName {\n";
    var fsons = FSON().parse(parseContent);
    fsons.forEach((fson) {
      
      if(currentIds.contains(fson.name)) {
        throw FormatException("Id already exists! at id: ${fson.name}");
      } else {
        currentIds.add(fson.name);
      }

      if((schema?.requiredKeys?.length ?? 0) < 1 && (schema?.keys?.length ?? 0) < 1) {
        throw FormatException("Required keys and optional keys shouldn't be null or empty at the same time. Use at least one of these to specify keys for your schema");
      }

      if((fson.keyValueNodes?.length ?? 0) < 1) throw FormatException("Please add Keys to FSONNode! At ${fson.name}"); 

      schema.requiredKeys?.forEach((k) {
          if(fson.keyValueNodes.any((f) => f.key == k) == false)
            throw FormatException("Key $k is required! At ${fson.name}!");
      });
  
      fson.keyValueNodes.forEach((kv) {
          if(schema.keys?.contains(kv.key) == false)
            throw FormatException("Key ${kv.key} not supported! At ${fson.name}!");
      });

      if(schema.fsonCustomValidate != null) {
        schema.fsonCustomValidate(fson);
      }

      Map<String,dynamic> map = {};

      fson.keyValueNodes.forEach((kv) {

        if(kv.arrayList.length > 0) {
          map["\"${kv.key}\""] = kv.arrayList;
        } 
        else {
          map["\"${kv.key}\""] = kv.value;
        }

      });

      finalContent += "\tstatic ${child.runtimeType} ${fson.name} = ${child.runtimeType}(map: ${map.toString()} ,name: \"${fson.name}\");\n";

    });

    finalContent += "}";
    File(relativePath + "/$saveOutputAs").writeAsString(finalContent);

  }

}