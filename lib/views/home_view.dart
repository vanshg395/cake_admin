import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../widgets/home_content.dart';
import '../extensions/hover_extensions.dart';
import '../providers/auth.dart';
import '../locator.dart';
import '../services/navigation_service.dart';
import '../routing/route_names.dart';
// import 'package:cake_admin/locator.dart';
// import 'package:cake_admin/services/navigation_service.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isLoading = false;

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  Future<void> checkLogin() async {
    setState(() {
      _isLoading = true;
    });
    final isAuth =
        await Provider.of<Auth>(context, listen: false).tryAutoLogin();
    setState(() {
      _isLoading = false;
    });
    if (!isAuth) {
      locator<NavigationService>().navigateTo(LoginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ResponsiveBuilder(
            builder: (context, sizingInfo) => Container(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 80,
                      color: Theme.of(context).accentColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: sizingInfo.isDesktop ? 36 : 24,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/img/logo.png'),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            child: Text(
                              'Home',
                              style: Theme.of(context).textTheme.headline5,
                            ).showCursorOnHover,
                            onTap: () {
                              // locator<NavigationService>().navigateTo('/login');
                            },
                          ),
                          Spacer(),
                          if (sizingInfo.isDesktop) ...[
                            Text(
                              Provider.of<Auth>(context, listen: false)
                                      .username ??
                                  '',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                          Icon(
                            FontAwesomeIcons.userCircle,
                            color: Colors.white,
                            size: 30,
                          ).showCursorOnHover,
                        ],
                      ),
                    ),
                    HomeContent(),
                  ],
                ),
              ),
            ),
          );
  }
}
