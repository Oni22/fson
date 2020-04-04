import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:fson/src/fson_base.dart';
import 'package:fson/src/fson_models.dart';
import 'package:fson/src/fson_schema.dart';
import 'package:fson/src/fson_validator.dart';

class FSON {

  static const String _projectNamespace = "fson";

  List<FSONNode> parse(String frData) {

    List<FSONNode> fsonModels = [];
    var idBlocks = frData.split(RegExp(r"\},"));
    idBlocks.removeWhere((s) => s.length == 0);

    idBlocks.forEach((block) {
      
      var idAndKeyValuePairs = block.split(RegExp(r"\{"));
      var fsonModel = FSONNode(
        name: idAndKeyValuePairs[0].trim(),
      );

      var keyValuePair = idAndKeyValuePairs[1];

      var fsonValidatorId = FSONValidator.validateStringId(fsonModel.name);
      if(!fsonValidatorId.isValid) {
         print("ID");
        throw FormatException(fsonValidatorId.message + " " + "at id: ${fsonModel.name}");
      }

      //REGEX: Match only commas outside of array
      keyValuePair.replaceAll("}","").trim().split(RegExp(r"(,)(?![^[]*\])")).forEach((keyValueRaw) {

        var keyValue = keyValueRaw.split(":");
        var key = keyValue[0].trim();
        var value = keyValue[1].trim();

        var keyValidator = FSONValidator.validateKey(key);
        if(!keyValidator.isValid) {
          print("KEY");
          throw FormatException(fsonValidatorId.message + " " + "at id: ${fsonModel.name}");
        }

        var keyValueNode = FSONKeyValueNode(
          key: key,
        );

        var fsonValidatorText = FSONValidator.validateText(value);
        if(!fsonValidatorText.isValid) {
          print("TEXT");
          throw FormatException(fsonValidatorText.message + " " + "at id: ${fsonModel.name}");
        }

        //Is array?
        //ERROR Multiline Array doenst work why?
        var testForArray = value.replaceAll("\n", "").trim();
        print(testForArray.replaceAll("[","").replaceAll("]", "").split(",").toString());
        if(testForArray.contains(RegExp(r"\[(.*?)\]"))) {
          print("IS ARRAY");
          var plurals = value.replaceAll("[", "").replaceAll("]", "").replaceAll("\n","").trim().split(",");
          keyValueNode.arrayList = plurals;
        } else {
          keyValueNode.value = value;
        }

        fsonModel.keyValueNodes.add(keyValueNode);
      });
      fsonModels.add(fsonModel);
    });
    return fsonModels;
  }

  void buildResource(FSONSchema schema,String namespace, String parentClassName,FSONBase child) async{

    if(child is FSONBase == false) {
      throw Exception("Membertype doens't extend from FSONBase class!");
    }

    var relativePath = path.relative("lib/$namespace/");
    var parseContent = await combineResources(relativePath);
    List<String> currentIds =  [];

    String finalContent = "import 'package:$_projectNamespace/$_projectNamespace.dart';\nclass $parentClassName {\n";
    var fsons = FSON().parse(parseContent);
    for(var fson in fsons) {
      
      if(schema.fsonCustomValidate != null) {
        schema.fsonCustomValidate(fson);
      }

      tryAddIdToList(currentIds, fson);

      if((schema?.requiredKeys?.length ?? 0) < 1 && (schema?.keys?.length ?? 0) < 1) {
        throw FormatException("Required keys and optional keys shouldn't be null or empty at the same time. Use at least one of these to specify keys for your schema");
      }

      if((fson.keyValueNodes?.length ?? 0) < 1) throw FormatException("Please add keys to FSONNode! At ${fson.name}"); 

      schema.requiredKeys?.forEach((k) {
          if(fson.keyValueNodes.any((f) => f.key == k) == false)
            throw FormatException("Key $k is required! At ${fson.name}!");
      });
  
      fson.keyValueNodes.forEach((kv) {
          if(schema.keys?.contains(kv.key) == false)
            throw FormatException("Key ${kv.key} not supported! At ${fson.name}!");
      });

      Map<String,dynamic> map = {};

      for(var kv in fson.keyValueNodes) {
        if(isReference(kv)) {
          var value = await fetchReference(kv);
          map["\"${kv.key}\""] = value ?? "";
        } else {
          if(kv.arrayList.length > 0) {
          map["\"${kv.key}\""] = kv.arrayList;
          } 
          else {
            map["\"${kv.key}\""] = kv.value;
          }
        }                 
      }
      finalContent += "\tstatic ${child.runtimeType} ${fson.name} = ${child.runtimeType}(map: ${map.toString()} ,name: \"${fson.name}\");\n";
    }

    finalContent += "}";
    File(relativePath + "/$namespace.fson.dart").writeAsString(finalContent);

  }

  void buildConfig() async{

    var relativePath = path.relative("lib/config/");
    var parseContent = await combineResources(relativePath);
    List<String> currentIds =  [];
    final String dimensionsId = "dimensions";

    String finalContent = "import 'package:$_projectNamespace/$_projectNamespace.dart';\nclass RBuildConfig {\n";
    var fsons = FSON().parse(parseContent);
    
    for(var fson in fsons) {
    
      tryAddIdToList(currentIds, fson);
      if(fson.name == dimensionsId && fson.keyValueNodes.length > 0){
        for(var kv in fson.keyValueNodes) {
          if(kv.key == "dimensions") {
              for(var dimen in kv.arrayList)
                finalContent += "\tbool is${dimen[0].toUpperCase() + dimen.substring(1)} => \"test\"";
          }
        }
      }

    }

    finalContent += "}";
    File(relativePath + "/flavor.fson.dart").writeAsString(finalContent);


  }

  Future<FSONKeyValueNode> loadKeyValueNode(String resourceId, String id, String key) async {
    var relativePath = path.relative("lib/$resourceId/");
    var parsedContent = await combineResources(relativePath);
    var node = parse(parsedContent).firstWhere((f) => f.name == id);
    return node.keyValueNodes.firstWhere((kv) => kv.key == key);
  }

  Future<String> combineResources(String directoryPath) async {
    var dir = Directory(directoryPath);

    if(!dir.existsSync()) { 
      dir.createSync();
    }

    var parseContent = "";
    var files = dir.listSync();
    files.removeWhere((f) => path.extension(f.path) != ".fson");
    print(files.length);
    if(files.length > 1) {
      for(var fileEntity in files) {
        print(fileEntity.path);
        if(path.extension(fileEntity.path) == ".fson") {
          var file = File(fileEntity.path);
          var content = await file.readAsString();
          parseContent += content.replaceAll("\n", "").trim() + ",";
        }
      }
    } else if(files.length == 1) {
      parseContent = await File(files[0].path).readAsString();
    }
    return parseContent;
  }

  bool isReference(FSONKeyValueNode kv) {
    if(kv?.value?.startsWith("\"#(") == true && kv?.value?.endsWith(")\"") == true) 
      return true;
    return false;
  }

  bool isExternalReference(FSONKeyValueNode kv) {
    if(isReference(kv)) {
      var splitted = kv.value.replaceAll("\"#(", "").replaceAll(")\"", "").split(".");
      if((splitted[0].contains("colors") || splitted[0].contains("styles") || splitted[0].contains("strings")) && splitted.length == 3) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future<String> fetchReference(FSONKeyValueNode kv) async {

    FSONKeyValueNode currentKV = kv;

    if(isReference(kv)) {
      var splitted = currentKV.value.replaceAll("\"#(", "").replaceAll(")\"", "").split(".");
      var namespace = "";
      var id = "";
      var key = "";
      
      if(isExternalReference(kv)) {
        namespace = splitted[0];
        id = splitted[1];
        key = splitted[2];
        var keyValue = await loadKeyValueNode(namespace, id, key);
        if(keyValue.arrayList.length > 0)
          throw FormatException("Referencing arrays is not supported! at ${keyValue.arrayList}");
        var fetched = await fetchReference(keyValue);
        return fetched;
      } 
    }
    return kv.value ?? "";
  }

  tryAddIdToList(List<String> ids,FSONNode node) {
    if(ids.contains(node.name)) {
        throw FormatException("Id already exists! at id: ${node.name}");
      } else {
        ids.add(node.name);
    }
  }
}
