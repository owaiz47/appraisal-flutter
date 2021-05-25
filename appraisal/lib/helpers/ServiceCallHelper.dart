import 'package:appraisal/UnAuthorizedException.dart';
import 'package:appraisal/components/MyToast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ServiceCallHelper {
  static callService(BuildContext context, Function blockFun) {
    try {
      blockFun();
    } on UnAuthorizedException catch (e) {
      MyToast.showSessionExpired(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyApp()));
    } catch (e) {
      MyToast.somethingWentWrong(context);
    }
  }
}
