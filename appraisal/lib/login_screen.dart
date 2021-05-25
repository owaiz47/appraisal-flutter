import 'package:appraisal/color_constants.dart';
import 'package:appraisal/components/MyToast.dart';
import 'package:appraisal/controllers/UserController.dart';
import 'package:appraisal/main.dart';
import 'package:appraisal/model/AuthRequest.dart';
import 'package:appraisal/views/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:velocity_x/velocity_x.dart';

import 'components/ToastChild.dart';
import 'components/my_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  String _errorMsg = "";
  bool login = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenHeight,
      child: Center(
        child: Container(
          width: context.isMobile
              ? context.screenWidth * 0.8
              : context.screenWidth * 0.4,
          child: Card(
            color: Color(k_blue_color),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      "assets/images/image.png",
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    _errorMsg,
                    style: TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  MyTextField(
                    controller: _usernameController,
                    icon: Icon(SimpleLineIcons.user),
                    hint: "Enter Username",
                    label: "Username",
                    showLabel: true,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  MyTextField(
                    controller: _passwordController,
                    icon: Icon(SimpleLineIcons.lock),
                    hint: "Enter Password",
                    label: "Password",
                    showLabel: true,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: 300.0,
                    height: 50.0,
                    child: RaisedButton(
                      color: login ? Colors.grey : Color(k_orange_color),
                      onPressed: () {
                        setState(() {
                          attemptLogin();
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: login
                            ? Container(
                                height: 50.0,
                                child: CircularProgressIndicator(
                                  backgroundColor: CupertinoColors.white,
                                ),
                              )
                            : Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(k_blue_color),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void attemptLogin() async {
    if (login) return;
    setState(() {
      login = true;
    });
    AuthRequest authRequest = new AuthRequest();
    authRequest.username = _usernameController.text;
    authRequest.password = _passwordController.text;
    UserController userController = new UserController();
    bool authenticated = await userController.login(authRequest);
    if (authenticated == null || !authenticated) {
      setState(() {
        login = false;
        _errorMsg = "Username or Password incorrect";
        Widget toast = ToastChild(
          text: "Login Failed",
          icon: Icon(
            Icons.highlight_remove,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        MyToast.showToast(context: context, toast: toast);
      });
    } else {
      Widget toast = ToastChild(
        text: "Login Successful",
        icon: Icon(
          Icons.highlight_remove,
          color: Colors.white,
        ),
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
      );
      MyToast.showToast(context: context, toast: toast);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => MyApp()));
    }
  }
}
