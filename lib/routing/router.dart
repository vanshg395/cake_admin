import 'package:flutter/material.dart';

import './route_names.dart';
import '../views/home_view.dart';
import '../views/login_view.dart';
import '../views/error_view.dart';
import '../views/order_view.dart';
import '../views/processing_order_view.dart';
import '../views/database_view.dart';
import '../views/settings_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeRoute:
      return _getPageRoute(HomeView(), settings);
    case LoginRoute:
      return _getPageRoute(LoginView(), settings);
    case RouteRoute:
      return _getPageRoute(HomeView(), settings);
    case OrderRoute:
      return _getPageRoute(OrderView(), settings);
    case ProcessingOrderRoute:
      return _getPageRoute(ProcessingOrderView(), settings);
    case DatabaseRoute:
      return _getPageRoute(DatabaseView(), settings);
    case SettingsRoute:
      return _getPageRoute(SettingsView(), settings);
    default:
      return _getPageRoute(ErrorView(), settings);
  }
}

Route getDefaultRoute(RouteSettings settings) {
  return _getPageRoute(LoginView(), settings);
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  _FadeRoute({this.child, this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
