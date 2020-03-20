
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:string_res/src/fson_core.dart';
import 'package:string_res/string_res.dart';

main(List<String> args) async{

  var supportedlangCodes = ["ab", "aa", "af", "ak", "sq", "am", "ar", "an", "hy", "as", "av", "ae", "ay", "az", "bm", "ba", "eu", "be", "bn", "bh", "bi", "bs", "br", "bg", "my", "ca", "ch", "ce", "ny", "zh", "cv", "kw", "co", "cr", "hr", "cs", "da", "dv", "nl", "dz", "en", "eo", "et", "ee", "fo", "fj", "fi", "fr", "ff", "gl", "ka", "de", "el", "gn", "gu", "ht", "ha", "he", "hz", "hi", "ho", "hu", "ia", "id", "ie", "ga", "ig", "ik", "io", "is", "it", "iu", "ja", "jv", "kl", "kn", "kr", "ks", "kk", "km", "ki", "rw", "ky", "kv", "kg", "ko", "ku", "kj", "la", "lb", "lg", "li", "ln", "lo", "lt", "lu", "lv", "gv", "mk", "mg", "ms", "ml", "mt", "mi", "mr", "mh", "mn", "na", "nv", "nb", "nd", "ne", "ng", "nn", "no", "ii", "nr", "oc", "oj", "cu", "om", "or", "os", "pa", "pi", "fa", "pl", "ps", "pt", "qu", "rm", "rn", "ro", "ru", "sa", "sc", "sd", "se", "sm", "sg", "sr", "gd", "sn", "si", "sk", "sl", "so", "st", "az", "es", "su", "sw", "ss", "sv", "ta", "te", "tg", "th", "ti", "bo", "tk", "tl", "tn", "to", "tr", "ts", "tt", "tw", "ty", "ug", "uk", "ur", "uz", "ve", "vi", "vo", "wa", "cy", "wo", "fy", "xh", "yi", "yo", "za", "zu"];
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

    if(fson.keyValueNodes.any((kv) => kv.key == RService.backUpLanguageCode) == false)
        throw FormatException("Please add backup language code to node!");

    fson.keyValueNodes.forEach((langTextModel) {

      if(!supportedlangCodes.contains(langTextModel.key))
        throw FormatException("Please use language codes from ISO-639-1 (e.g en or de)");

      //add language backup check

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