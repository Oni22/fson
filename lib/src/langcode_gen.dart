import 'dart:convert';
import 'dart:io';

void gen_lang() async{
  var content = json.decode(await File("lib/src/iso.json").readAsString());
  List<String> codes = [];
  content.forEach((m) {codes.add("\"${m["code"]}\"");});
  print(codes);
}