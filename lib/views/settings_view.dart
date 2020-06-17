import 'dart:convert';
import 'dart:html';
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
    } else {
      getData();
    }
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
      if (response.statusCode == 200) {
        final resBody = json.decode(response.body);
        setState(() {
          _users = resBody['payload'];
        });
      }
    } catch (e) {}
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _changePassword(String username) async {
    await showDialog(
      context: context,
      // barrierDismissible: false,
      child: StatefulBuilder(
        builder: (context, setState) => Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            width: 300,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Enter New Password',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline6
                            .copyWith(
                              color: Colors.black,
                            ),
                      ),
                      GestureDetector(
                        child: Icon(Icons.cancel),
                        onTap: () {
                          Navigator.of(context).pop();
                          return;
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 300,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'New Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                          borderSide: BorderSide(
                            width: 0,
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                          borderSide: BorderSide(
                            width: 0,
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                          borderSide: BorderSide(
                            width: 0,
                            color: Colors.grey,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                          borderSide: BorderSide(
                            width: 0,
                            color: Colors.grey,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                          borderSide: BorderSide(
                            width: 0,
                            color: Colors.grey,
                          ),
                        ),
                        errorStyle: TextStyle(color: Colors.red[200]),
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == '') {
                          return 'This field is required.';
                        }
                      },
                      onSaved: (value) {
                        _data['password'] = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  AltButton(
                    title: 'Change Password',
                    borderRadius: 2,
                    fontSize: 16,
                    width: 300,
                    height: 50,
                    bgColor: Theme.of(context).accentColor,
                    borderColor: Colors.white,
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(
                      //     builder: (ctx) => MenuScreen(),
                      //   ),
                      // );
                      try {
                        final url = baseUrl + 'api/core/users/';
                        final response = await http.post(
                          url,
                          headers: {
                            HttpHeaders.authorizationHeader:
                                Provider.of<Auth>(context, listen: false).token,
                            HttpHeaders.contentTypeHeader: 'application/json',
                          },
                          body: json.encode({
                            'username': username,
                            'password': _data['password'],
                          }),
                        );
                        Navigator.of(context).pop();
                        if (response.statusCode == 204) {
                        } else {
                          showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Text('Error'),
                              content: Text(
                                  'Password could not be changed due to some reason.'),
                              actions: [
                                FlatButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          );
                        }
                      } catch (e) {}
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
                              DataColumn(
                                label: Text(
                                  'Action',
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
                                        DataCell(
                                          RaisedButton(
                                            child: Text('Change Password'),
                                            onPressed: () {
                                              _changePassword(
                                                  user['user']['username']);
                                            },
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
