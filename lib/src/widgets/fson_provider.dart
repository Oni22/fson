
import 'package:flutter/material.dart';

import '../../fson.dart';

class FsonProvider extends StatefulWidget {
  
  final Widget child;
  final List<Locale> supportedLocales;
  final Locale fallbackLocale;


  FsonProvider({
    Key key,
    this.child,
    this.supportedLocales,
    this.fallbackLocale
    }) : super(key: key);

  @override
  _FsonProviderState createState() => _FsonProviderState();
}

class _FsonProviderState extends State<FsonProvider> with WidgetsBindingObserver {

  @override
  void didChangeLocales(List<Locale> locales) {
    super.didChangeLocales(locales);

    for(var locale in locales) {
      if(widget.supportedLocales.contains(locale)) {
        setState(() {
          RConfig.currentLanguageCode = WidgetsBinding.instance.window.locale.languageCode;
        });
        return;
      }
    }

    setState(() {
      RConfig.backUpLanguageCode = WidgetsBinding.instance.window.locale.languageCode;
    });

  }

  @override
  void initState() {
    super.initState();
    RConfig.backUpLanguageCode = widget.fallbackLocale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}