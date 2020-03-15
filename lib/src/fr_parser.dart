
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:string_res/string_res.dart';

class FRParser {

  List<_Language> langs = [];

  List<RString> toRStrings(String frData) {

    List<RString> strings = [];
    var idBlocks = frData.split(RegExp(r"\},"));
    idBlocks.removeWhere((s) => s.length == 0);

    idBlocks.forEach((block) {
      var blockNameLangs = block.split(RegExp(r"\{"));
      var name = blockNameLangs[0].trim();
      var langs = blockNameLangs[1];

      if(!validateStringId(name)) {
        throw FormatException("FSON_ERROR: Id name has unsupported characters. Only underscores are allowed in id names! at id: $name");
      }

      Map<String,dynamic> langMap = {};
      langs.replaceAll("}","").replaceAll("},","").trim().split(RegExp(r"(,)(?![^[]*\])")).forEach((lang) {
        var langCodeText = lang.split(":");
        var langCode = langCodeText[0].trim();

        if(!validateISO6391(langCode)) {
          throw FormatException("FSON_ERROR: Language code wrong or not supported at id: $name");
        }

        var text = langCodeText[1].trim();
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

  buildLangList() async{
    var jsonData = json.decode(await File("lib/src/iso6391codes.json").readAsString());
    jsonData.forEach((d) {
      langs.add(_Language.parse(d));
    });
  }

  bool validateStringId(String name) {
    if(name.contains(RegExp(r"[^a-z^A-Z^0-9\^_]+"))) 
      return false;
    else 
      return true;
  }
  
  bool validateISO6391(String code) {
    var lang = langs.firstWhere((l) => l.code == code,orElse: () => null);
    return lang != null;
  }

}

class _Language {
  String code;
  String name;

  _Language.parse(dynamic data) {
    code = data["code"];
    name = data["name"];
  }

}