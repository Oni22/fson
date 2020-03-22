import 'package:flutter/widgets.dart';
import 'package:string_res/src/fson_base.dart';

class RStyle extends FSONBase {

  RStyle({
    map,
    name
  }) : super(map: map,name: name);

  double get fontSize => double.parse(getKey("textSize"));
  String get fontFamily => map["fontFamily"];
  int get fontColor => _hexToInt(getKey("textColor"));
  int get backgroundColor => _hexToInt(getKey("backgroundColor"));
  String get debugLabel => getKey("debugLabel");
  bool get inherit => getKey("inherit");
  int get color => _hexToInt(getKey("color"));
  double get letterSpacing => double.parse(getKey("letterSpacing"));
  double get wordSpacing => double.parse(getKey("wordSpacing"));
  double get height => double.parse(getKey("height"));
  double get width => double.parse(getKey("width"));

  
  FontWeight getFontWeight() {
    switch(getKey("fontWeight")) {
      case "bold": 
        return FontWeight.bold;
      case "normal": 
        return FontWeight.normal;
      case "w100": 
        return FontWeight.w100;
      case "w200": 
        return FontWeight.w200;
      case "w300": 
        return FontWeight.w300;
      case "w400": 
        return FontWeight.w400;
      case "w500": 
        return FontWeight.w500;
      case "w600": 
        return FontWeight.w600;
      case "w700": 
        return FontWeight.w700;
      case "w800": 
        return FontWeight.w800;
      case "w900": 
        return FontWeight.w900;
      default: 
        return FontWeight.normal;
    }
  }
  
  FontStyle getFontStyle() {
    switch(getKey("fontStyle")){
      case "italic":
        return FontStyle.italic;
      case "normal":
        return FontStyle.normal;
      default:
        return FontStyle.normal;
    }
  }

  TextBaseline _getTextBaseLine() {
    switch(getKey("textBaseline")){
      case "alphabetic":
        return TextBaseline.alphabetic;
      case "normal":
        return TextBaseline.ideographic;
      default:
        return TextBaseline.alphabetic;
    }
  }

  int _hexToInt(String hex) {
    var hexColor = hex.toUpperCase().replaceAll("#","");
    if(hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor,radix: 16);
  }

}

//TextStyle({Paint foreground, Paint background, List<Shadow> shadows, List<FontFeature> fontFeatures, TextDecoration decoration, Color decorationColor, TextDecorationStyle decorationStyle, double decorationThickness, String fontFamily, List<String> fontFamilyFallback, String package})