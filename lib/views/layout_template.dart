import 'package:flutter/material.dart';

import '../widgets/footer.dart';

class LayoutTemplate extends StatelessWidget {
  final Widget child;
  const LayoutTemplate({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: child,
          ),
          Footer()
        ],
      ),
    );
  }
}
