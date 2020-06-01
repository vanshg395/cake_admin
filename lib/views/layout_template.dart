import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/footer.dart';

class LayoutTemplate extends StatelessWidget {
  final Widget child;
  const LayoutTemplate({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 50,
              constraints: BoxConstraints(
                minHeight: max(MediaQuery.of(context).size.height - 50, 700),
              ),
              child: child,
            ),
            Footer(),
          ],
        ),
      ),
    );
  }
}
