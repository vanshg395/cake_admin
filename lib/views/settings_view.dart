import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:http/http.dart' as http;

import '../extensions/hover_extensions.dart';
import '../providers/auth.dart';
import '../locator.dart';
import '../services/navigation_service.dart';
import '../routing/route_names.dart';
import '../utils/constants.dart';
import '../widgets/alt_button.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _isLoading = false;
  List<dynamic> _users = [];
  GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, dynamic> _data = {};

  @override
  void initState() {
    super.initState();
    checkLogin();
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
    getData();
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final url = baseUrl + 'api/core/users/';
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader:
              Provider.of<Auth>(context, listen: false).token,
        },
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final resBody = json.decode(response.body);
        setState(() {
          _users = resBody['payload'];
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
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
                child: SingleChildScrollView(
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
                            GestureDetector(
                              child: Image.asset('assets/img/logo.png'),
                              onTap: () => locator<NavigationService>()
                                  .navigateTo(HomeRoute),
                            ).showCursorOnHover,
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              child: Text(
                                'Settings',
                                style: Theme.of(context).textTheme.headline5,
                              ).showCursorOnHover,
                              onTap: () {
                                // locator<NavigationService>().navigateTo('/login');
                              },
                            ),
                            Spacer(),
                            if (sizingInfo.isDesktop) ...[
                              Text(
                                Provider.of<Auth>(context).username ?? '',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                            PopupMenuButton(
                              icon: Icon(
                                FontAwesomeIcons.userCircle,
                                color: Colors.white,
                                size: 30,
                              ).showCursorOnHover,
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  value: 'Logout',
                                ),
                              ],
                              onSelected: (value) async {
                                if (value == 'Logout') {
                                  await Provider.of<Auth>(context,
                                          listen: false)
                                      .logout();
                                  checkLogin();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            dataRowHeight: 80,
                            sortColumnIndex: 5,
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'S.No.',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Username',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'First Name',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Last Name',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Email',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'User Type',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                            rows: _users
                                .map((user) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Text(
                                            (_users.indexOf(user) + 1)
                                                .toString(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            user['user']['username'] ?? '',
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            user['user']['first_name'] ?? '',
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            user['user']['last_name'] ?? '',
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            user['user']['email'] ?? '',
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            user['user']['is_superuser']
                                                ? 'Admin'
                                                : 'Worker' ?? '',
                                          ),
                                        ),

                                        // DataCell(Container(
                                        //   height: 200,
                                        //   width: 100,
                                        //   color: Colors.red,
                                        // )),
                                      ],
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
