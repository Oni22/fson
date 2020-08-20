
import 'package:flutter/material.dart';
import 'package:fson/fson.dart';


class Loco extends StatefulWidget {
  
  final Widget child;
  final List<Locale> supportedLocales;
  final Locale fallbackLocale;


  Loco({
    Key key,
    this.child,
    this.supportedLocales,
    this.fallbackLocale
    }) : super(key: key);

  @override
  _LocoState createState() => _LocoState();
}

class _LocoState extends State<Loco> with WidgetsBindingObserver {

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
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    RConfig.backUpLanguageCode = widget.fallbackLocale.languageCode;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Subscribe to changes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}