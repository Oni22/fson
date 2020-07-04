// import 'package:flutter/widgets.dart';
// import 'package:fson/fson.dart';

// class FSONUtils {
//   static Locale setLanguage(Locale currentLocale, List<Locale> supportedLocales,
//       {String backUpLanguage = "en"}) {
//     for (var supported in supportedLocales) {
//       if (supported.countryCode == currentLocale.countryCode &&
//           supported.languageCode == currentLocale.languageCode) {
//         // assign language code if it is supported
//         RConfig.currentLanguageCode = supported.languageCode;
//         return supported;
//       }
//     }
//     // assign your back up language code if couldn't find supported language
//     RConfig.backUpLanguageCode = backUpLanguage;
//     return currentLocale;
//   }

//   static setDarkMode(bool enable) {
//     RConfig.isDarkMode = enable;
//   }
// }
