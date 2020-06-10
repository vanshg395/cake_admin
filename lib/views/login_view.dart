import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/common_button.dart';
import '../providers/auth.dart';
import '../locator.dart';
import '../services/navigation_service.dart';
import '../routing/route_names.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isObscure = true;
  bool _isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _data = {};

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
    if (isAuth) {
      locator<NavigationService>().navigateTo(HomeRoute);
    }
  }

  Future<void> _submit() async {
    _formKey.currentState.save();
    if (!_formKey.currentState.validate()) {
      return;
    }
    String errorMessage = 'Some Error Ocurred.';
    try {
      await Provider.of<Auth>(context, listen: false).login(_data);
      locator<NavigationService>().navigateTo(HomeRoute);
    } catch (e) {
      print(e);
      if (e.toString() == 'Not an Admin') {
        errorMessage =
            'This user is not an admin. Please use an Admin account.';
      } else if (e.toString() == 'Invalid Details') {
        errorMessage = 'The credentials entered were incorrect.';
      } else {
        errorMessage = 'Internal Server Error';
      }

      await showDialog(
        context: context,
        child: AlertDialog(
          title: Text(
            'Error',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            errorMessage,
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
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
                child: Form(
                  key: _formKey,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(
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
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                validator: (value) {
                                  if (value == '') {
                                    return 'This field is required.';
                                  }
                                },
                                onSaved: (value) {
                                  _data['username'] = value;
                                },
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
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                validator: (value) {
                                  if (value == '') {
                                    return 'This field is required.';
                                  }
                                },
                                onSaved: (value) {
                                  _data['password'] = value;
                                },
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
                              fontSize: MediaQuery.of(context).size.width < 600
                                  ? 16
                                  : 26,
                              width: MediaQuery.of(context).size.width < 600
                                  ? 200
                                  : 250,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF64CCF9),
                                  Color(0xFFA334F4),
                                ],
                              ),
                              onPressed: _submit,
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
            ),
          );
  }
}
