import 'package:appraisal/color_constants.dart';
import 'package:appraisal/model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:velocity_x/velocity_x.dart';

import 'MyToast.dart';
import 'ToastChild.dart';
import 'my_text_field.dart';

class AddManagerWidget {
  TextEditingController usernameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController nameTextEditingController = new TextEditingController();
  bool isAdmin = false;
  final BuildContext context;
  User user;

  AddManagerWidget(this.context, {this.user});
  Future<User> buildShowAddFormDialog() {
    if (user != null) {
      usernameTextEditingController.text = user.username;
      passwordTextEditingController.text = user.password;
      nameTextEditingController.text = user.fullname;
      emailTextEditingController.text = user.email;
      isAdmin = user.admin;
    }
    return showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  insetPadding: EdgeInsets.symmetric(horizontal: 10),
                  contentPadding: EdgeInsets.only(
                      top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
                  content: Container(
                    height: context.isMobile
                        ? MediaQuery.of(context).size.height * 0.7
                        : MediaQuery.of(context).size.height * 0.3,
                    width: context.isMobile
                        ? MediaQuery.of(context).size.width * 1
                        : MediaQuery.of(context).size.height * 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              context.isMobile
                                  ? Column(
                                      children: buildFirstInfoWid(),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: buildFirstInfoWid(),
                                    ),
                              SizedBox(
                                height: 5.0,
                              ),
                              context.isMobile
                                  ? Column(
                                      children: buildSecondInfoWid(),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: buildSecondInfoWid(),
                                    ),
                              Container(
                                width: 180.0,
                                child: CheckboxListTile(
                                    activeColor: Color(k_blue_color),
                                    dense: true,
                                    //font change
                                    title: new Text(
                                      "Admin",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5),
                                    ),
                                    value: isAdmin,
                                    onChanged: (bool val) {
                                      setState(() {
                                        isAdmin = val;
                                      });
                                    }),
                              ),
                            ],
                          ),
                        ),
                        RaisedButton(
                          color: Color(k_blue_color),
                          onPressed: () {
                            String name = nameTextEditingController.text;
                            String email = emailTextEditingController.text;
                            String username =
                                usernameTextEditingController.text;
                            String password =
                                passwordTextEditingController.text;
                            if (name.replaceAll(" ", "").isEmpty ||
                                email.replaceAll(" ", "").isEmpty ||
                                username.replaceAll(" ", "").isEmpty ||
                                password.replaceAll(" ", "").isEmpty) {
                              MyToast.showToast(
                                context: context,
                                toast: ToastChild(
                                    textColor: Colors.white,
                                    text: "Please add all information",
                                    icon: Icon(
                                      Entypo.cross,
                                      color: Colors.white,
                                    ),
                                    backgroundColor: Colors.red),
                              );
                              return null;
                            }
                            if (user == null) user = new User();
                            user.email = email;
                            user.fullname = name;
                            user.username = username;
                            user.password = password;
                            user.admin = isAdmin;

                            //newUsers.add(user);
                            Navigator.pop(context, user);
                            /*Navigator.of(context, rootNavigator: true,)
                                .pop('dialog');*/
                            setState(() {
                              nameTextEditingController.text = "";
                              passwordTextEditingController.text = "";
                              usernameTextEditingController.text = "";
                              emailTextEditingController.text = "";
                              isAdmin = false;
                            });
                            return user;
                          },
                          child: Text(
                            user == null ? "Add" : "Save",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ));
  }

  List<Widget> buildFirstInfoWid({readOnly = false}) {
    return [
      context.isMobile
          ? UsernameTextField(readonly: readOnly)
          : Expanded(
              child: UsernameTextField(readonly: readOnly),
            ),
      SizedBox(
        height: 5.0,
        width: 5.0,
      ),
      context.isMobile
          ? emailTF(readonly: readOnly)
          : Expanded(
              child: emailTF(readonly: readOnly),
            ),
    ];
  }

  MyTextField UsernameTextField({bool readonly = false}) {
    return MyTextField(
      readOnly: readonly,
      icon: Icon(Feather.user),
      controller: usernameTextEditingController,
      showLabel: false,
      hint: "Manager Username",
    );
  }

  MyTextField emailTF({bool readonly = false}) {
    return MyTextField(
      readOnly: readonly,
      icon: Icon(Icons.mail_outline),
      controller: emailTextEditingController,
      showLabel: false,
      hint: "Manager Email",
    );
  }

  buildSecondInfoWid({readOnly = false}) {
    return [
      context.isMobile
          ? PasswordTF(readonly: readOnly)
          : Expanded(
              child: PasswordTF(readonly: readOnly),
            ),
      SizedBox(
        height: 5.0,
        width: 5.0,
      ),
      context.isMobile
          ? NameTF(readonly: readOnly)
          : Expanded(
              child: NameTF(readonly: readOnly),
            ),
    ];
  }

  MyTextField PasswordTF({bool readonly = false}) {
    return MyTextField(
      readOnly: readonly,
      icon: Icon(Icons.design_services_outlined),
      controller: passwordTextEditingController,
      showLabel: false,
      hint: "Password",
    );
  }

  MyTextField NameTF({bool readonly = false}) {
    return MyTextField(
      readOnly: readonly,
      icon: Icon(FontAwesome.user),
      controller: nameTextEditingController,
      showLabel: false,
      hint: "Manager Name",
    );
  }
}
