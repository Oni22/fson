
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:string_res/string_res.dart';

class FRParser {

  List<RString> toRStrings(String frData) {

    List<RString> strings = [];
    var idBlocks = frData.split(RegExp(r"\},"));
    idBlocks.removeWhere((s) => s.length == 0);

    idBlocks.forEach((block) {
      var blockNameLangs = block.split(RegExp(r"\{"));
      var name = blockNameLangs[0].trim();
      var langs = blockNameLangs[1];

      var fsonValidatorId = validateStringId(name);
      if(!fsonValidatorId.isValid) {
        throw FormatException(fsonValidatorId.message + " " + "at id: $name");
      }

      Map<String,dynamic> langMap = {};
      langs.replaceAll("}","").replaceAll("},","").trim().split(RegExp(r"(,)(?![^[]*\])")).forEach((lang) {
        var langCodeText = lang.split(":");
        var langCode = langCodeText[0].trim();

        if(!validateISO6391(langCode)) {
          throw FormatException("FSON_ERROR: Language code wrong or not supported at id: $name");
        }

        var text = langCodeText[1].trim();
        var fsonValidatorText = validateText(text);
        if(!fsonValidatorText.isValid) {
          throw FormatException(fsonValidatorText.message + " m" + "at id: $name");
        }

        if(text.contains(RegExp(r"\[(.*?)\]"))) {
          var plurals = text.replaceAll("[", "").replaceAll("]", "").trim().split(",");
          langMap["\"$langCode\""] = plurals;
        } else {
          langMap["\"$langCode\""] = text;
        }
      });
      strings.add(RString(langs: langMap,name: name));
    });
    return strings;
  }

  FSONValidatorError validateStringId(String name) {
    if(name.contains(RegExp(r"[^a-z^A-Z^0-9\^_]+"))) 
      return FSONValidatorError(isValid: false, message: "FSON_ERROR: Id name has unsupported characters. Only underscores are allowed in id names!");
    else 
      return FSONValidatorError(isValid: true, message: "");
  }

  FSONValidatorError validateText(String text) {
    if(text.contains(RegExp(r"\[(.*?)\]"))) {
      var rawPlurals = text.replaceAll("[", "").replaceFirst("]", "");
      if(rawPlurals.contains("[") || rawPlurals.contains("]")) {
        return FSONValidatorError(isValid: false, message: "FSON_ERROR: Plurals inside plurals are not allowed!");
      }
      var validatedPlurals = rawPlurals.trim().split(",");
      //"[^"]*"
      for(var p in validatedPlurals) {
        if(!p.startsWith("\"") || !p.endsWith("\"")) {
          return FSONValidatorError(isValid: false, message: "FSON_ERROR: Text must be a string!");
        } else {
          var r = p.replaceAll(RegExp(r"^.|.$"),"");
          if(r.contains("\"")) { //NOT FINAL
            return FSONValidatorError(isValid: false,message:"FSON_ERROR: Please escape with \\""\" inside a string");
          }    
        }
      }
      return FSONValidatorError(isValid: true,message: "");
    }
    print(text);
    return FSONValidatorError(isValid: text.startsWith("\"") && text.endsWith("\"") ? true : false,message: "");
  }
  
  bool validateISO6391(String code) {
    var lang = RService.locales.firstWhere((l) => l == code,orElse: () => null);
    return lang != null;
  }

}

class FSONValidatorError {
  String message;
  bool isValid;
  FSONValidatorError({this.isValid,this.message});
}