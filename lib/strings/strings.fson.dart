import 'package:string_res/string_res.dart';
class S {
	static RString standart = RString(map: {"en": "aaa", "tr": "merhaba", "de": "Hello"} ,name: "standart");
	static RString plurals = RString(map: {"en": "asdasd", "de": ["eins", "zwei"]} ,name: "plurals");
	static RString placeholder = RString(map: {"en": "I'm a %1p placeholder and %2p second", "de": "Ich bin %1p platzhalter und %2p zwei"} ,name: "placeholder");
	static RString plural_place = RString(map: {"en": ["Hi boy %1p", "Hi boy %1p %2p cool %3p"], "de": ["Hi junge %1p", "Hi junge %1p %2p cool %3p"]} ,name: "plural_place");
	static RString plural_place_two = RString(map: {"en": ["Hi boy %1p", "Hi boy %1p %2p cool %3p"], "de": ["Hi junge %1p", "Hi junge %1p %2p cool %3p"]} ,name: "plural_place_two");
	static RString test = RString(map: {"en": "Das ist aber cool", "de": "This is so cool"} ,name: "test");
	static RString from_second = RString(map: {"en": "Hallo", "de": "standart"} ,name: "from_second");
	static RString from_sec = RString(map: {"en": "Cool", "de": ["eins", "zwei"]} ,name: "from_sec");
	static RString from_second_world = RString(map: {"en": "Cool", "de": ["eins", "zwei"]} ,name: "from_second_world");
}