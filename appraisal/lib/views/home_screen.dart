import 'package:appraisal/UnAuthorizedException.dart';
import 'package:appraisal/color_constants.dart';
import 'package:appraisal/components/MyToast.dart';
import 'package:appraisal/components/ToastChild.dart';
import 'package:appraisal/components/add_skill_component.dart';
import 'package:appraisal/components/employee_add_component.dart';
import 'package:appraisal/components/manager_add_component.dart';
import 'package:appraisal/components/my_text_field.dart';
import 'package:appraisal/controllers/EmployeeController.dart';
import 'package:appraisal/controllers/SkillController.dart';
import 'package:appraisal/controllers/UserController.dart';
import 'package:appraisal/model/Employee.dart';
import 'package:appraisal/model/Skill.dart';
import 'package:appraisal/model/User.dart';
import 'package:appraisal/repository/UserStorage.dart';
import 'package:appraisal/views/add_employees_screen.dart';
import 'package:appraisal/views/add_manager_screen.dart';
import 'package:appraisal/views/add_skill_screen.dart';
import 'package:appraisal/views/employee_rate_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:velocity_x/velocity_x.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with
        AutomaticKeepAliveClientMixin<HomeScreen>,
        SingleTickerProviderStateMixin {
  List<Employee> employees;
  List<User> users;
  List<Skill> skills;
  TabController _tabController;
  int _currentIndex = 0;
  TextEditingController _serachController = new TextEditingController();
  @override
  void dispose() {
    _serachController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchEmployees();
    fetchUsers();
    fetchSkills();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChanged);
    _serachController.addListener(_handleSearchChanged);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        MyToast.showToast(
          context: context,
          toast: ToastChild(
              textColor: Colors.black,
              text: "Please close the window to exit",
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              backgroundColor: Colors.white),
        );
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    color: CupertinoColors.white,
                    width: double.infinity,
                    height: 50.0,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Appraisal Matrix",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(k_blue_color)),
                            ),
                            IconButton(
                                icon: Icon(Icons.refresh),
                                onPressed: () {
                                  _refresh();
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  buildTopNav(),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    color: Colors.grey.shade50,
                    width: double.infinity,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      unselectedLabelColor:
                          Color(k_blue_color).withOpacity(0.5),
                      labelColor: Color(k_blue_color),
                      indicatorColor: Color(k_blue_color),
                      tabs: [
                        Container(
                          width: context.screenWidth * (0.9 / 3),
                          child: Tab(
                            child: Row(
                              children: [
                                Icon(SimpleLineIcons.user),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text("Employees"),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: context.screenWidth * (0.9 / 3),
                          child: Tab(
                            child: Row(
                              children: [
                                Icon(FontAwesome.id_card_o),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text("Managers"),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: context.screenWidth * (0.9 / 3),
                          child: Tab(
                            child: Row(
                              children: [
                                Icon(Foundation.social_skillshare),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text("Skills"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          buildEmployeeList(),
                          buildManagerList(),
                          buildSkillsList(),
                        ],
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void fetchEmployees() async {
    setState(() {
      employees = null;
    });
/*    ServiceCallHelper.callService(context, () async {
      EmployeeController employeeController = new EmployeeController();
      employees = await employeeController.getEmployees();
      setState(() {});
    });*/
    try {
      EmployeeController employeeController = new EmployeeController();
      employees = await employeeController.getEmployees();
      setState(() {});
    } on UnAuthorizedException catch (e) {
      MyToast.showSessionExpired(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyApp()));
    } catch (e) {
      MyToast.somethingWentWrong(context);
    }
  }

  void fetchUsers() async {
    setState(() {
      users = null;
    });
    try {
      UserController userController = new UserController();
      users = await userController.getUsers();
      setState(() {});
    } on UnAuthorizedException catch (e) {
      MyToast.showSessionExpired(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyApp()));
      print(e);
    } catch (e) {
      MyToast.somethingWentWrong(context);
      print(e);
    }
  }

  void fetchSkills() async {
    setState(() {
      skills = null;
    });
    try {
      SkillController skillController = new SkillController();
      skills = await skillController.getSkills();
      setState(() {});
    } on UnAuthorizedException catch (e) {
      MyToast.showSessionExpired(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyApp()));
      print(e);
    } catch (e) {
      MyToast.somethingWentWrong(context);
      print(e);
    }
  }

  Future<void> _refresh() async {
    fetchEmployees();
    fetchUsers();
    fetchSkills();
    return true;
  }

  buildEmployeeList() {
    return employees == null
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(k_blue_color),
                valueColor: new AlwaysStoppedAnimation<Color>(
                  Color(k_orange_color),
                ),
              ),
            ),
          )
        : (employees.isEmpty
            ? Stack(
                children: [
                  Container(
                    child: Center(
                      child: Text(
                        "No Employees Added",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ),
                  ListView(),
                ],
              )
            : ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () async {
                      bool rated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  EmployeeRateScreen(
                                    employee: employees[i],
                                  )));
                      if (rated) fetchEmployees();
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage:
                                        AssetImage("assets/images/manager.png"),
                                    radius: 25.0,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    employees[i].employeeName,
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.mail_outline,
                                    size: 30.0,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    employees[i].email,
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Octicons.calendar,
                                    size: 30.0,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    employees[i].experience.toString() +
                                        "Years",
                                    style: TextStyle(fontSize: 14.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Octicons.star,
                                    color: Colors.yellow,
                                    size: 30.0,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    "  " +
                                        employees[i].averageRating.toString(),
                                    style: TextStyle(fontSize: 14.0),
                                  )
                                ],
                              ),
                            ),
                            FlatButton.icon(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                label: Text(
                                  "Delete",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14.0),
                                ),
                                onPressed: () {
                                  deleteEmployee(employees[i]);
                                }),
                            IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  AddEmployeeWidget addWid =
                                      new AddEmployeeWidget(context,
                                          employee: employees[i]);
                                  Employee emp =
                                      await addWid.buildShowAddFormDialog();
                                  if (emp != null) {
                                    employees[i] = emp;
                                    saveEmployee(emp);
                                    setState(() {});
                                    MyToast.showToast(
                                      context: context,
                                      toast: ToastChild(
                                        backgroundColor: Colors.greenAccent,
                                        icon: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                        text: "Employee Update Successful",
                                        textColor: Colors.white,
                                      ),
                                    );
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  );
                }));
  }

  buildManagerList() {
    return users == null
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(k_blue_color),
                valueColor: new AlwaysStoppedAnimation<Color>(
                  Color(k_orange_color),
                ),
              ),
            ),
          )
        : (users.isEmpty
            ? Stack(
                children: [
                  Container(
                    child: Center(
                      child: Text(
                        "No Managers Added",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ),
                  ListView(),
                ],
              )
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage:
                                      AssetImage("assets/images/manager.png"),
                                  radius: 25.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  users[i].fullname,
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.mail_outline,
                                  size: 30.0,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  users[i].email,
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  users[i].admin
                                      ? MaterialIcons.verified_user
                                      : Octicons.unverified,
                                  color: users[i].admin
                                      ? Colors.green
                                      : CupertinoColors.destructiveRed,
                                  size: 30.0,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  users[i].admin ? "Admin" : "Not Admin",
                                  style: TextStyle(
                                      color: users[i].admin
                                          ? Colors.green
                                          : CupertinoColors.destructiveRed,
                                      fontSize: 14.0),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: authenticatedUser.admin &&
                                    users[i].id != authenticatedUser.id
                                ? FlatButton.icon(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    label: Text(
                                      "Delete",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 14.0),
                                    ),
                                    onPressed: () {
                                      deleteUser(users[i]);
                                    })
                                : SizedBox(),
                          ),
                          authenticatedUser.admin
                              ? IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    AddManagerWidget addWidget =
                                        new AddManagerWidget(context,
                                            user: users[i]);
                                    User user = await addWidget
                                        .buildShowAddFormDialog();
                                    if (user != null) {
                                      users[i] = user;
                                      saveUser(user);
                                      setState(() {});
                                      MyToast.showToast(
                                        context: context,
                                        toast: ToastChild(
                                          backgroundColor: Colors.greenAccent,
                                          icon: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          ),
                                          text: "User Updated",
                                          textColor: Colors.white,
                                        ),
                                      );
                                    }
                                  })
                              : SizedBox(),
                        ],
                      ),
                    ),
                  );
                }));
  }

  buildSkillsList() {
    return skills == null
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(k_blue_color),
                valueColor: new AlwaysStoppedAnimation<Color>(
                  Color(k_orange_color),
                ),
              ),
            ),
          )
        : (skills.isEmpty
            ? Stack(
                children: [
                  Container(
                    child: Center(
                      child: Text(
                        "No Skills Added",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ),
                  ListView(),
                ],
              )
            : ListView.builder(
                itemCount: skills.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Foundation.text_color,
                                  size: 30.0,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  "Skill:",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  skills[i].skillName,
                                  style: TextStyle(fontSize: 15.0),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(MaterialCommunityIcons.weight, size: 30.0),
                                SizedBox(width: 5.0),
                                Text(
                                  "Weightage:",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  skills[i].weightage.toString(),
                                  style: TextStyle(fontSize: 15.0),
                                )
                              ],
                            ),
                          ),
                          /*Expanded(
                            child: FlatButton.icon(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                label: Text(
                                  "Delete",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14.0),
                                ),
                                onPressed: () {
                                  deleteSkill(skills[i]);
                                }),
                          )*/
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                AddSkillWidget addWid = new AddSkillWidget(
                                    context,
                                    skill: skills[i]);
                                Skill sk =
                                    await addWid.buildShowAddFormDialog();
                                if (sk != null) {
                                  skills[i] = sk;
                                  saveSkill(sk);
                                  MyToast.showToast(
                                    context: context,
                                    toast: ToastChild(
                                      backgroundColor: Colors.greenAccent,
                                      icon: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                      text: "Skill Updated Successfully",
                                      textColor: Colors.white,
                                    ),
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                  );
                }));
  }

  buildTopNav() {
    return _currentIndex == 0
        ? buildEmployeeNav()
        : (_currentIndex == 1 ? buildManagerNav() : buildSkillsNav());
  }

  buildEmployeeNav() {
    return buildTopBar(
      label: "Employee Details",
      buttonIconData: AntDesign.adduser,
      buttonLabel: "Add Employees",
      onPressed: () async {
        bool added = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => AddEmployeesScreen()));
        if (added) fetchEmployees();
      },
    );
  }

  buildManagerNav() {
    return buildTopBar(
        label: "Manager Details",
        buttonIconData: FontAwesome.address_card_o,
        buttonLabel: "Add Managers",
        onPressed: () async {
          bool added = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddManagersScreen()));
          if (added) fetchUsers();
        },
        showButton: authenticatedUser.admin);
  }

  buildSkillsNav() {
    return buildTopBar(
        label: "Skills Details",
        buttonIconData: Foundation.social_skillshare,
        buttonLabel: "Add Skills",
        onPressed: () async {
          bool added = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddSkillScreen()));
          if (added) fetchSkills();
        });
  }

  void _handleTabChanged() {
    if (_currentIndex != _tabController.index) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

  void _handleSearchChanged() {
    if (_currentIndex == 0) {
      searchEmployees();
    } else if (_currentIndex == 1) {
      searchUsers();
    } else {
      searchSkills();
    }
  }

  void deleteUser(User user) async {
    _showMyDialog(
        message: "Do you want to delete ${user.fullname}",
        head: "Confirm Delete",
        onYes: () async {
          try {
            UserController userController = new UserController();
            bool delete = await userController.deleteUser(user);
            if (delete != null && delete) {
              users.remove(user);
              setState(() {});
            }
          } on UnAuthorizedException catch (e) {
            MyToast.showSessionExpired(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => MyApp()));
          } catch (e) {
            MyToast.somethingWentWrong(context);
          }
        });
  }

  Future<void> _showMyDialog(
      {String head, String message, Function onYes}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(head),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //Text('Confirm Delete.'),
                Text('$message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                Navigator.of(context).pop();
                onYes();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                return false;
              },
            ),
          ],
        );
      },
    );
  }

  void deleteEmployee(Employee employee) async {
    _showMyDialog(
        message: "Do you want to delete ${employee.employeeName}",
        head: "Confirm Delete",
        onYes: () async {
          try {
            EmployeeController employeeController = new EmployeeController();
            bool delete = await employeeController.deleteEmployee(employee);
            if (delete != null && delete) {
              employees.remove(employee);
              setState(() {});
            }
          } on UnAuthorizedException catch (e) {
            MyToast.showSessionExpired(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => MyApp()));
          } catch (e) {
            MyToast.somethingWentWrong(context);
          }
        });
  }

  void deleteSkill(Skill skill) {
    _showMyDialog(
        message: "Do you want to delete ${skill.skillName}",
        head: "Confirm Delete",
        onYes: () async {
          try {
            SkillController skillController = new SkillController();
            bool delete = await skillController.deleteSkill(skill);
            if (delete != null && delete) {
              skills.remove(skill);
              setState(() {});
            }
          } on UnAuthorizedException catch (e) {
            MyToast.showSessionExpired(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => MyApp()));
          } catch (e) {
            MyToast.somethingWentWrong(context);
          }
        });
  }

  buildTopBar(
      {String label,
      String buttonLabel,
      Function onPressed,
      IconData buttonIconData,
      bool showButton = true}) {
    String hint = "";
    if (_currentIndex == 0) {
      hint = "by employee name";
    } else if (_currentIndex == 1) {
      hint = "by manager username or name";
    } else {
      hint = "by skill name";
    }
    return Container(
      color: Color(k_orange_color).withOpacity(0.8),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: MyTextField(
                  controller: _serachController,
                  showLabel: false,
                  icon: Icon(SimpleLineIcons.magnifier),
                  hint: "Search $hint",
                ),
              ),
            ),
            Container(
              height: 50.0,
              width: 180.0,
              child: showButton
                  ? RaisedButton.icon(
                      onPressed: onPressed,
                      icon: Icon(
                        buttonIconData,
                        color: Colors.white,
                      ),
                      label: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          buttonLabel,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      color: Color(k_blue_color),
                    )
                  : SizedBox(),
            )
          ],
        ),
      ),
    );
  }

  void searchEmployees() async {
    if (_serachController.text.replaceAll(" ", "").isEmpty) {
      fetchEmployees();
      return;
    }
    setState(() {
      employees = null;
    });
    try {
      EmployeeController employeeController = new EmployeeController();
      employees =
          await employeeController.getEmployeesByName(_serachController.text);
      setState(() {});
    } on UnAuthorizedException catch (e) {
      MyToast.showSessionExpired(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyApp()));
    } catch (e) {
      MyToast.somethingWentWrong(context);
    }
  }

  void searchUsers() async {
    if (_serachController.text.replaceAll(" ", "").isEmpty) {
      fetchUsers();
      return;
    }
    setState(() {
      users = null;
    });
    try {
      UserController userController = new UserController();
      users = await userController.getUsersByName(_serachController.text);
      setState(() {});
    } on UnAuthorizedException catch (e) {
      MyToast.showSessionExpired(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyApp()));
      print(e);
    } catch (e) {
      MyToast.somethingWentWrong(context);
      print(e);
    }
  }

  void searchSkills() async {
    if (_serachController.text.replaceAll(" ", "").isEmpty) {
      fetchSkills();
      return;
    }
    setState(() {
      skills = null;
    });
    try {
      SkillController skillController = new SkillController();
      skills = await skillController.getSkillsByName(_serachController.text);
      setState(() {});
    } on UnAuthorizedException catch (e) {
      MyToast.showSessionExpired(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyApp()));
      print(e);
    } catch (e) {
      MyToast.somethingWentWrong(context);
      print(e);
    }
  }

  void saveUser(User user) async {
    try {
      UserController userController = new UserController();
      bool saved = await userController.saveUser(user);
      if (saved == null || !saved) throw Exception("failed");
      if (user.id == authenticatedUser.id) {
        authenticatedUser.admin = user.admin;
        setState(() {});
      }
    } on UnAuthorizedException catch (e) {
      MyToast.showSessionExpired(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyApp()));
      print(e);
    } catch (e) {
      MyToast.somethingWentWrong(context);
      print(e);
    }
  }

  void saveEmployee(Employee emp) async {
    try {
      EmployeeController employeeController = new EmployeeController();
      bool saved = await employeeController.saveEmployee(emp);
      if (saved == null || !saved) throw Exception("failed");
    } on UnAuthorizedException catch (e) {
      MyToast.showSessionExpired(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyApp()));
      print(e);
    } catch (e) {
      MyToast.somethingWentWrong(context);
      print(e);
    }
  }

  void saveSkill(Skill sk) async {
    try {
      SkillController skillController = new SkillController();
      bool saved = await skillController.saveSkill(sk);
      if (saved == null || !saved) throw Exception("failed");
    } on UnAuthorizedException catch (e) {
      MyToast.showSessionExpired(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyApp()));
      print(e);
    } catch (e) {
      MyToast.somethingWentWrong(context);
      print(e);
    }
  }
}
