import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Footer extends StatefulWidget {
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  DateTime currentDateTime = DateTime.now();

  @override
  void initState() {
    updateTime();
    super.initState();
  }

  void updateTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentDateTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      color: Theme.of(context).accentColor,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat.yMMMMd().format(currentDateTime),
            style: Theme.of(context).textTheme.caption,
          ),
          Text(
            DateFormat.Hms().format(currentDateTime),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
