import 'package:appraisal/UnAuthorizedException.dart';
import 'package:appraisal/components/MyToast.dart';
import 'package:appraisal/components/ToastChild.dart';
import 'package:appraisal/components/manager_add_component.dart';
import 'package:appraisal/controllers/UserController.dart';
import 'package:appraisal/main.dart';
import 'package:appraisal/model/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:velocity_x/velocity_x.dart';

class AddManagersScreen extends StatefulWidget {
  @override
  _AddManagersScreenState createState() => _AddManagersScreenState();
}

class _AddManagersScreenState extends State<AddManagersScreen> {
  List<User> newUsers = new List<User>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _back,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: _back,
            icon: Icon(Icons.arrow_back),
          ),
          title: Text("Add New Managers"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.blueAccent,
              ),
              onPressed: () async {
                AddManagerWidget addManagerWidget = new AddManagerWidget(
                  context,
                );
                User user = await addManagerWidget.buildShowAddFormDialog();
                if (user != null) newUsers.add(user);
                setState(() {});
              },
            ),
            FlatButton(
              onPressed: () {
                save();
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
        body: Center(
          child: ListView.builder(
            itemCount: newUsers.length,
            itemBuilder: (context, i) {
              if (newUsers[i] == null) return SizedBox();
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            context.isMobile
                                ? Column(
                                    children:
                                        buildShowFirstInfoWid(newUsers[i]),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children:
                                        buildShowFirstInfoWid(newUsers[i]),
                                  ),
                            SizedBox(
                              height: 5.0,
                            ),
                            context.isMobile
                                ? Column(
                                    children:
                                        buildShowSecondInfoWid(newUsers[i]),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children:
                                        buildShowSecondInfoWid(newUsers[i]),
                                  ),
                            Container(
                              width: 180.0,
                              child: CheckboxListTile(
                                  activeColor: Colors.pink[300],
                                  dense: true,
                                  //font change
                                  title: new Text(
                                    "Admin",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5),
                                  ),
                                  value: newUsers[i].admin,
                                  onChanged: (bool val) {}),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteEmp(i);
                          }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _back() async {
    Navigator.pop(context, false);
    return false;
  }

  void deleteEmp(int index) {
    newUsers.removeAt(index);
    setState(() {});
  }

  void save() async {
    if (newUsers.isEmpty) {
      MyToast.showToast(
          toast: ToastChild(
              backgroundColor: Colors.red,
              icon: Icon(
                Entypo.cross,
                color: Colors.white,
              ),
              text: "No Employees Added",
              textColor: Colors.white),
          context: context);
    }
    try {
      UserController userController = new UserController();
      bool saved = await userController.saveUsers(newUsers);
      if (saved == null || !saved) {
        MyToast.somethingWentWrong(context);
        return;
      }
      Navigator.pop(context, true);
    } on UnAuthorizedException catch (e) {
      MyToast.showSessionExpired(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyApp()));
    } catch (e) {
      MyToast.somethingWentWrong(context);
    }
  }

  List<Widget> buildShowFirstInfoWid(User user) {
    return [
      context.isMobile
          ? UsernameShowField(user)
          : Expanded(
              child: UsernameShowField(user),
            ),
      SizedBox(
        height: 5.0,
        width: 5.0,
      ),
      context.isMobile
          ? emailShowF(user)
          : Expanded(
              child: emailShowF(user),
            ),
    ];
  }

  Widget UsernameShowField(User user) {
    return showcaseCard(user.username, Icon(Feather.user));
  }

  Widget emailShowF(User user) {
    return showcaseCard(user.email, Icon(Feather.mail));
  }

  List<Widget> buildShowSecondInfoWid(User user) {
    return [
      context.isMobile
          ? PasswordShowField(user)
          : Expanded(
              child: PasswordShowField(user),
            ),
      SizedBox(
        height: 5.0,
        width: 5.0,
      ),
      context.isMobile
          ? NameShowField(user)
          : Expanded(
              child: NameShowField(user),
            ),
    ];
  }

  Widget PasswordShowField(User user) {
    return showcaseCard(user.password, Icon(SimpleLineIcons.lock));
  }

  Widget NameShowField(User user) {
    return showcaseCard(user.fullname, Icon(FontAwesome.user));
  }

  Widget showcaseCard(String value, Icon icon) {
    return Container(
      height: 50.0,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              icon,
              SizedBox(
                width: 50.0,
              ),
              Text(value),
            ],
          ),
        ),
      ),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
}
