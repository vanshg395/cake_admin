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

class DatabaseView extends StatefulWidget {
  @override
  _DatabaseViewState createState() => _DatabaseViewState();
}

class _DatabaseViewState extends State<DatabaseView> {
  bool _isLoading = false;
  List<dynamic> _users = [];
  GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, dynamic> _data = {
    'recipients': [],
  };

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
      final url = baseUrl + 'api/core/dblist/';
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
          _users = resBody['user_list'];
        });
      }
    } catch (e) {}
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
                                'Database',
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
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            child: Text('Send General Messages'),
                            onPressed: () async {
                              for (var i = 0; i < _users.length; i++) {
                                _data['recipients'].add(_users[i]['phone']);
                              }
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Enter Details',
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
                                                maxLines: 3,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 20,
                                                          vertical: 10),
                                                  hintText: 'Message',
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    borderSide: BorderSide(
                                                      width: 0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    borderSide: BorderSide(
                                                      width: 0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    borderSide: BorderSide(
                                                      width: 0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    borderSide: BorderSide(
                                                      width: 0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    borderSide: BorderSide(
                                                      width: 0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  errorStyle: TextStyle(
                                                      color: Colors.red[200]),
                                                ),
                                                style: TextStyle(
                                                    color: Colors.black),
                                                validator: (value) {
                                                  if (value == '') {
                                                    return 'This field is required.';
                                                  }
                                                },
                                                onSaved: (value) {
                                                  _data['general_message'] =
                                                      value;
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            AltButton(
                                              title: 'Confirm Order',
                                              borderRadius: 2,
                                              fontSize: 16,
                                              width: 300,
                                              height: 50,
                                              bgColor:
                                                  Theme.of(context).accentColor,
                                              borderColor: Colors.white,
                                              onPressed: () async {
                                                if (!_formKey.currentState
                                                    .validate()) {
                                                  return;
                                                }
                                                _formKey.currentState.save();
                                                // Navigator.of(context).pushReplacement(
                                                //   MaterialPageRoute(
                                                //     builder: (ctx) => MenuScreen(),
                                                //   ),
                                                // );
                                                try {
                                                  final url = baseUrl +
                                                      'api/core/message/';
                                                  final response =
                                                      await http.post(
                                                    url,
                                                    headers: {
                                                      HttpHeaders
                                                              .authorizationHeader:
                                                          Provider.of<Auth>(
                                                                  context,
                                                                  listen: false)
                                                              .token,
                                                      HttpHeaders
                                                              .contentTypeHeader:
                                                          'application/json'
                                                    },
                                                    body: json.encode({
                                                      "message": _data[
                                                          'general_message'],
                                                      "phones":
                                                          _data['recipients'],
                                                    }),
                                                  );
                                                } catch (e) {}
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.white,
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            dataRowHeight: 80,
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'S.No.',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Name',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Phone Number',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Occasions',
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
                                            user['name'],
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            user['phone'],
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ...user['occasion']
                                                  .map(
                                                    (occ) => Container(
                                                      width: 200,
                                                      child: ListTile(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                          right: 10,
                                                        ),
                                                        leading: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      15.0),
                                                          child: CircleAvatar(
                                                            child: Text(
                                                              (user['occasion']
                                                                          .indexOf(
                                                                              occ) +
                                                                      1)
                                                                  .toString(),
                                                            ),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          occ['name'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          DateFormat.yMMMd()
                                                              .format(DateTime
                                                                  .parse(occ[
                                                                      'order_date'])),
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList()
                                            ],
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
