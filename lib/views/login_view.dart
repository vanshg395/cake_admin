import 'dart:math';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/centered_view.dart';
import '../widgets/common_button.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
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
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                alignment: Alignment.center,
                constraints: BoxConstraints(
                  maxWidth: 500,
                  minHeight: 500,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Welcome',
                      style: Theme.of(context).textTheme.headline3.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                      // margin: EdgeInsets.symmetric(
                      //   horizontal: 30,
                      // ),
                      width: MediaQuery.of(context).size.width * 0.5,
                      constraints: BoxConstraints(
                        maxWidth: 300,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Username',
                          focusColor: Theme.of(context).primaryColor,
                        ),
                        // style: MediaQuery.of(context).size.width < 600
                        //     ? Theme.of(context)
                        //         .primaryTextTheme
                        //         .bodyText2
                        //         .copyWith(color: Colors.black)
                        //     : Theme.of(context)
                        //         .primaryTextTheme
                        //         .bodyText1
                        //         .copyWith(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      constraints: BoxConstraints(
                        maxWidth: 300,
                      ),
                      child: TextFormField(
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          // contentPadding: EdgeInsets.only(),
                          labelText: 'Password',
                          focusColor: Theme.of(context).primaryColor,
                          suffixIcon: InkWell(
                            child: Icon(
                              _isObscure
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              size: 18,
                            ),
                            onTap: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                        // style: MediaQuery.of(context).size.width < 600
                        //     ? Theme.of(context)
                        //         .primaryTextTheme
                        //         .bodyText2
                        //         .copyWith(color: Colors.black)
                        //     : Theme.of(context)
                        //         .primaryTextTheme
                        //         .bodyText1
                        //         .copyWith(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    CommonButton(
                      title: 'Dive In',
                      borderRadius: 30,
                      fontSize:
                          MediaQuery.of(context).size.width < 600 ? 16 : 26,
                      width:
                          MediaQuery.of(context).size.width < 600 ? 200 : 250,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF64CCF9),
                          Color(0xFFA334F4),
                        ],
                      ),
                      onPressed: () {
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //     builder: (ctx) => MenuScreen(),
                        //   ),
                        // );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
