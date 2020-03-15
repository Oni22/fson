import 'package:string_res/string_res.dart';
class R {
	static RString standart = RString(langs: {"en": "Hallo", "de": "Hello"} ,name: "standart");
	static RString plurals = RString(langs: {"en": "Cool", "de": ["eins", "zwei"]} ,name: "plurals");
	static RString placeholder = RString(langs: {"en": "I'm a %1p placeholder and %2p second", "de": "Ich bin %1p platzhalter und %2p zwei"} ,name: "placeholder");
	static RString plural_place = RString(langs: {"en": ["Hi boy %1p", "Hi boy %1p %2p cool %3p"], "de": ["Hi junge %1p", "Hi junge %1p %2p cool %3p"]} ,name: "plural_place");
	static RString plural_place_two = RString(langs: {"en": ["Hi boy %1p", "Hi boy %1p %2p cool %3p"], "de": ["Hi junge %1p", "Hi junge %1p %2p cool %3p"]} ,name: "plural_place_two");
	static RString from_sec = RString(langs: {"en": "Hallo", "de": "Hello"} ,name: "from_sec");
	static RString from_second = RString(langs: {"en": "Cool", "de": ["eins", "zwei"]} ,name: "from_second");
}