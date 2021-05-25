import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'ToastChild.dart';

class MyToast {
  static showToast(
      {BuildContext context,
      Widget toast,
      ToastGravity gravity = ToastGravity.CENTER}) {
    FToast fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: toast,
      gravity: gravity,
      toastDuration: Duration(seconds: 2),
      positionedToastBuilder: (context, child) {
        return Positioned(
          child: child,
          bottom: 16.0,
          left: 16.0,
        );
      },
    );
  }

  static showSessionExpired(BuildContext context) {
    MyToast.showToast(
        context: context,
        toast: ToastChild(
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            text: "Session Expired",
            textColor: Colors.white));
  }

  static somethingWentWrong(BuildContext context) {
    MyToast.showToast(
        context: context,
        toast: ToastChild(
            backgroundColor: Colors.redAccent,
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            text: "Something went wrong",
            textColor: Colors.white));
  }
}
