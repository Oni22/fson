

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FSONData extends ChangeNotifier {

}


class FsonProvider extends StatefulWidget {
  
  final Widget child;

  FsonProvider({
    Key key,
    this.child
    }) : super(key: key);

  @override
  _FsonProviderState createState() => _FsonProviderState();
}

class _FsonProviderState extends State<FsonProvider> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FSONData>(
      create: (context) => FSONData(),
      child: widget.child,
    );
  }
}