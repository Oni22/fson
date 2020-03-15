 

import 'package:string_res/src/r_service.dart';

class RString {

  RString({
    this.langs,
    this.name,
    });
  String name;

  Map<String,dynamic> langs = {};

  String get _text {
    if(langs.containsKey(RService.currentLanguageCode)) {
      return langs[RService.currentLanguageCode];
    }
    return langs[RService.backUpLanguageCode];
  }

  String text({List<dynamic> params}) {
    if((params?.length ?? 0) > 0) {
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

    var currentLangCode = langCode == "" ? RService.currentLanguageCode : langCode;

    if(langs.containsKey(currentLangCode)){
      if(langs[currentLangCode] is List<String>) {
        if((params?.length ?? 0) > 0)  
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