import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:http/http.dart' as http;

import '../extensions/hover_extensions.dart';
import '../providers/auth.dart';
import '../locator.dart';
import '../services/navigation_service.dart';
import '../routing/route_names.dart';
import '../utils/constants.dart';

class OrderView extends StatefulWidget {
  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  bool _isLoading = false;
  List<dynamic> _orders = [];

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
    try {
      final url = baseUrl + 'api/core/order/pending/';
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
          _orders = resBody['payload'];
        });
      }
    } catch (e) {
      print(e);
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
                            Image.asset('assets/img/logo.png'),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              child: Text(
                                'Orders',
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
                            Icon(
                              FontAwesomeIcons.userCircle,
                              color: Colors.white,
                              size: 30,
                            ).showCursorOnHover,
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
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'S.No.',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Name',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Phone Number',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Email',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Date of Delivery',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Message on Cake',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Special Instructions',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Eggless',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Quantity',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Weight (Kg)',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Price (₹)',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
                            rows: _orders
                                .map((order) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Text(
                                            (_orders.indexOf(order) + 1)
                                                .toString(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            order['name'],
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            order['phone_number'],
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            order['email'],
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            order['date_of_delivery']
                                                .toString()
                                                .substring(0, 10),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            order['message_on_cake'],
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            order['special_instructions'],
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            order['eggless'] ? 'YES' : 'NO',
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            order['quantity'].toString(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            order['weight'].toString(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            order['total_amount'].toString(),
                                          ),
                                        ),
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
