import 'package:fson_parser/fson_parser.dart';
import 'package:fson/src/r_config.dart';

class RString extends FSONBase {
  RString({
    map,
    name,
  }) : super(map: map, name: name);

  String _getTextFromKey() {
    if (map.containsKey(RConfig.currentLanguageCode)) {
      return map[RConfig.currentLanguageCode];
    }
    return map[RConfig.backUpLanguageCode];
  }

  String text({List<dynamic> params}) {
    
    if ((params?.length ?? 0) > 0) {
      return _setTextParams(_getTextFromKey(), params);
    }

    return _getTextFromKey();
  }

  String _setTextParams(String text, List<dynamic> params) {
    var paramsText = text;
    params.forEach((p) {
      paramsText = paramsText.replaceAll("%${params.indexOf(p) + 1}p", "$p");
    });
    return paramsText;
  }

  String plural(int quantity, {List<dynamic> params, String langCode = ""}) {
    var currentLangCode =
        langCode == "" ? RConfig.currentLanguageCode : langCode;

    if (map.containsKey(currentLangCode)) {
      if (map[currentLangCode] is List<String>) {
        if ((params?.length ?? 0) > 0)
          return _setTextParams(map[currentLangCode][quantity], params);
        else
          return map[currentLangCode][quantity];
      } else
        return "Error lang code hasn't plurals!";
    } else {
      return "Error lang code doenst exist!";
    }
  }
}
