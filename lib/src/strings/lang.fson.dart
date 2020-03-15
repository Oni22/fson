import 'package:string_res/string_res.dart';
class R {
	static RString test_text = RString(langs: {"en": "Hallo", "de": "Hello"} ,name: "test_text");
	static RString test_text_two = RString(langs: {"en": "Cool", "de": ["eins", "zwei"]} ,name: "test_text_two");
}