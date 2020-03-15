 

import 'package:string_res/src/r_service.dart';

class RString {

  RString({
    this.langs,
    this.name,
    });
  String name;

  Map<String,dynamic> langs = {};

  String get _text => langs[RService.languageCode];

  String text({List<dynamic> params}) {
    if(params.length > 0) {
      return _setTextParams(_text, params);
    }
    return _text;
  }

  String _setTextParams(String text,List<dynamic> params) {
    var paramsText = text;
    params.forEach((p) {
      paramsText = paramsText.replaceAll("%${params.indexOf(p) + 1}p", "$p");
    });
    return paramsText;
  }

  String plural(int quantity,{List<dynamic> params,String langCode = ""}) {

    var currentLangCode = langCode == "" ? RService.languageCode : langCode;

    if(langs.containsKey(currentLangCode)){
      if(langs[currentLangCode] is List<String>) {
        if(params != null && params.length > 0)  
          return _setTextParams(langs[currentLangCode][quantity],params);
        else 
          return langs[currentLangCode][quantity];
      }
      else 
        return "Error lang code hasn't plurals!";
    } else {
        return "Error lang code doenst exist!";
    }
  }

}