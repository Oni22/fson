import 'package:string_res/src/fson_models.dart';
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
}