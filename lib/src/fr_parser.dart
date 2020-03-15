
import 'package:string_res/string_res.dart';

class FRParser {

  List<RString> strings = [];

  FRParser.toRStrings(String frData) {
    var idBlocks = frData.split("},");

    idBlocks.forEach((block) {
      var blockNameLangs = block.split("{");
      var name = blockNameLangs[0].trim();
      var langs = blockNameLangs[1];

      var langList = langs.replaceAll("}","").trim().split(RegExp(r"(,)(?![^[]*\])")).map((lang) {
          var langCodeText = lang.split(":");
          var langCode = langCodeText[0].trim();
          var text = langCodeText[1].trim();
          return {"code": langCode,"text": text};
      }).toList();

      var map = Map<String,dynamic>();

      langList.forEach((item) {
        var text =  item["text"];
        var langCode =  item["code"];

        if(text.startsWith("[") && text.endsWith("]")) {
            var plurals = text.replaceAll("[", "").replaceAll("]", "").trim().split(",");
            map["\"$langCode\""] = plurals;
        } else {
           map["\"$langCode\""] = text;
        }
      });
      strings.add(RString(langs: map,name: name));
    });
  }

}