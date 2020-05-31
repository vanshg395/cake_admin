import 'package:flutter/material.dart';
import './views/layout_template.dart';

import 'locator.dart';
import './services/navigation_service.dart';
import './routing/router.dart';
import './routing/route_names.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Bake Admin',
      theme: ThemeData(
        primaryColor: Color(0xFF1188E3),
        accentColor: Color(0xFF292827),
        canvasColor: Color(0xFF1d2628),
        textTheme: TextTheme(
          caption: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      builder: (context, child) => LayoutTemplate(
        child: child,
      ),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: HomeRoute,
      // home: ,
    );
  }
}