import 'dart:convert';
import 'dart:io';

import 'package:cake_admin/widgets/alt_button.dart';
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
import '../widgets/dropdown.dart';

class OrderView extends StatefulWidget {
  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  bool _isLoading = false;
  List<dynamic> _orders = [];
  String _orderType;
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
      final url = baseUrl + 'api/core/order/pending/';
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader:
              Provider.of<Auth>(context, listen: false).token,
        },
      );
      print(response.statusCode);
      // print(response.body);
      if (response.statusCode == 200) {
        final resBody = json.decode(response.body);
        setState(() {
          _orders = resBody['payload'];
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _processOrder(String orderId, String totalAmount) async {
    _orderType = null;
    await showDialog(
      context: context,
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
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'Advance Amount Paid',
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
                        if (double.tryParse(value) == null) {
                          return 'Enter valid value.';
                        }
                      },
                      onSaved: (value) {
                        _data['balance'] =
                            double.parse(totalAmount) - double.parse(value);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MultilineDropdownButtonFormField(
                    // isExpanded: true,
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          'Pickup',
                          style: TextStyle(color: Colors.black),
                        ),
                        value: 'Pickup',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Delivery',
                          style: TextStyle(color: Colors.black),
                        ),
                        value: 'Delivery',
                      ),
                    ],
                    value: _orderType,
                    iconSize: MediaQuery.of(context).size.width < 600 ? 40 : 50,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Theme.of(context).primaryColor,
                    ),
                    iconEnabledColor: Theme.of(context).cardColor,
                    iconDisabledColor: Theme.of(context).cardColor,
                    onChanged: (val) {
                      if (_orderType == 'Delivery') {
                        _data['address'] = null;
                      }
                      setState(() {
                        _orderType = val;
                      });
                    },
                    decoration: InputDecoration(
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
                      hintText: 'Order Type',
                      hintStyle: TextStyle(
                        fontSize: 16,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 16,
                      ),
                      contentPadding: EdgeInsets.only(
                        left: 20,
                        right: 10,
                      ),
                      errorStyle: TextStyle(color: Colors.red[200]),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'This field is required.';
                      }
                    },
                    onSaved: (value) {
                      _data['order_type'] = value;
                      // _data['quantity'] = value;
                    },
                  ),
                  if (_orderType == 'Delivery') ...[
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
                          hintText: 'Address',
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
                          _data['address'] = value;
                        },
                      ),
                    ),
                  ],
                  SizedBox(
                    height: 30,
                  ),
                  AltButton(
                    title: 'Process Order',
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
                        final url = baseUrl + 'api/core/order/pending/';
                        final response = await http.post(
                          url,
                          headers: {
                            HttpHeaders.authorizationHeader:
                                Provider.of<Auth>(context, listen: false).token,
                            HttpHeaders.contentTypeHeader: 'application/json',
                          },
                          body: _data['address'] == null
                              ? json.encode({
                                  'order': orderId,
                                  'approval': true,
                                  'total_amount': double.parse(totalAmount),
                                  'balance': _data['balance'],
                                  'order_type': _data['order_type'],
                                })
                              : json.encode({
                                  'order': orderId,
                                  'approval': true,
                                  'total_amount': double.parse(totalAmount),
                                  'balance': _data['balance'],
                                  'order_type': _data['order_type'],
                                  'address': _data['address'],
                                }),
                        );
                        print(response.statusCode);
                        if (response.statusCode == 201) {
                          Navigator.of(context).pop();
                          await showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Text(
                                'Success',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              content: Text(
                                'You order is now processing.',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
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
                          getData();
                        } else {
                          await showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Text(
                                'Error',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              content: Text(
                                'You order could not be processed.',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
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
                      } catch (e) {
                        print(e);
                      }
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
                                'Approvals',
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
                                  'Email',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Date of Delivery',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Cake Name',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Cake Type',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Message on Cake',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Special Instructions',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Eggless',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Quantity',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Weight (Kg)',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Price (₹)',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Actions',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                            rows: _orders
                                .map(
                                  (order) => DataRow(
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
                                          order['cake_name'],
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          order['cake_department'],
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
                                      DataCell(
                                        RaisedButton(
                                          child: Text('Process Order'),
                                          onPressed: () => _processOrder(
                                              order['id'].toString(),
                                              order['total_amount'].toString()),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
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
