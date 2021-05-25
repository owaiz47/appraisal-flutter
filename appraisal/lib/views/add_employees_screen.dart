import 'package:appraisal/UnAuthorizedException.dart';
import 'package:appraisal/color_constants.dart';
import 'package:appraisal/components/MyToast.dart';
import 'package:appraisal/components/ToastChild.dart';
import 'package:appraisal/components/my_text_field.dart';
import 'package:appraisal/controllers/EmployeeController.dart';
import 'package:appraisal/main.dart';
import 'package:appraisal/model/Employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:velocity_x/velocity_x.dart';

class AddEmployeesScreen extends StatefulWidget {
  @override
  _AddEmployeesScreenState createState() => _AddEmployeesScreenState();
}

class _AddEmployeesScreenState extends State<AddEmployeesScreen> {
  List<Employee> newEmployees = new List<Employee>();
  TextEditingController empNameTextEditingController =
      new TextEditingController();
  TextEditingController empEmailTextEditingController =
      new TextEditingController();
  TextEditingController empDesigTextEditingController =
      new TextEditingController();
  TextEditingController empYearTextEditingController =
      new TextEditingController();
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
          title: Text("Add New Employees"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.blueAccent,
              ),
              onPressed: () {
                buildShowAddFormDialog(context);
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
            itemCount: newEmployees.length,
            itemBuilder: (context, i) {
              if (newEmployees[i] == null) return SizedBox();
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
                                        buildShowFirstInfoWid(newEmployees[i]),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children:
                                        buildShowFirstInfoWid(newEmployees[i]),
                                  ),
                            SizedBox(
                              height: 5.0,
                            ),
                            context.isMobile
                                ? Column(
                                    children:
                                        buildShowSecondInfoWid(newEmployees[i]),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children:
                                        buildShowSecondInfoWid(newEmployees[i]),
                                  )
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

  List<Widget> buildFirstInfoWid({readOnly = false}) {
    return [
      context.isMobile
          ? employeeTextField(readonly: readOnly)
          : Expanded(
              child: employeeTextField(readonly: readOnly),
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

  MyTextField employeeTextField({bool readonly = false}) {
    return MyTextField(
      readOnly: readonly,
      icon: Icon(Feather.user),
      controller: empNameTextEditingController,
      showLabel: false,
      hint: "Employee Name",
    );
  }

  MyTextField emailTF({bool readonly = false}) {
    return MyTextField(
      readOnly: readonly,
      icon: Icon(Icons.mail_outline),
      controller: empEmailTextEditingController,
      showLabel: false,
      hint: "Employee Email",
    );
  }

  buildSecondInfoWid({readOnly = false}) {
    return [
      context.isMobile
          ? designationTF(readonly: readOnly)
          : Expanded(
              child: designationTF(readonly: readOnly),
            ),
      SizedBox(
        height: 5.0,
        width: 5.0,
      ),
      context.isMobile
          ? experienceTF(readonly: readOnly)
          : Expanded(
              child: experienceTF(readonly: readOnly),
            ),
    ];
  }

  MyTextField designationTF({bool readonly = false}) {
    return MyTextField(
      readOnly: readonly,
      icon: Icon(Icons.design_services_outlined),
      controller: empDesigTextEditingController,
      showLabel: false,
      hint: "Designation",
    );
  }

  MyTextField experienceTF({bool readonly = false}) {
    return MyTextField(
      readOnly: readonly,
      icon: Icon(AntDesign.calendar),
      controller: empYearTextEditingController,
      showLabel: false,
      hint: "Experience In Years",
    );
  }

  void deleteEmp(int index) {
    newEmployees.removeAt(index);
    setState(() {});
  }

  void save() async {
    if (newEmployees.isEmpty) {
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
      EmployeeController employeeController = new EmployeeController();
      bool saved = await employeeController.saveEmployees(newEmployees);
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

  Future buildShowAddFormDialog(BuildContext contextin) {
    return showDialog(
        context: contextin,
        builder: (_) => AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              contentPadding: EdgeInsets.only(
                  top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
              content: Container(
                height: contextin.isMobile
                    ? MediaQuery.of(context).size.height * 0.7
                    : MediaQuery.of(context).size.height * 0.25,
                width: contextin.isMobile
                    ? MediaQuery.of(context).size.width * 1
                    : MediaQuery.of(context).size.height * 1,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          contextin.isMobile
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
                          contextin.isMobile
                              ? Column(
                                  children: buildSecondInfoWid(),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: buildSecondInfoWid(),
                                )
                        ],
                      ),
                    ),
                    RaisedButton(
                      color: Color(k_blue_color),
                      onPressed: () {
                        String name = empNameTextEditingController.text;
                        String email = empEmailTextEditingController.text;
                        String designation = empDesigTextEditingController.text;
                        String years = empYearTextEditingController.text;
                        if (name.replaceAll(" ", "").isEmpty ||
                            email.replaceAll(" ", "").isEmpty ||
                            designation.replaceAll(" ", "").isEmpty ||
                            years.replaceAll(" ", "").isEmpty) {
                          MyToast.showToast(
                            context: contextin,
                            toast: ToastChild(
                                textColor: Colors.white,
                                text: "Please add all information",
                                icon: Icon(
                                  Entypo.cross,
                                  color: Colors.white,
                                ),
                                backgroundColor: Colors.red),
                          );
                          return;
                        }
                        if (!isNumeric(years)) {
                          MyToast.showToast(
                            context: contextin,
                            toast: ToastChild(
                                textColor: Colors.white,
                                text:
                                    "Only Numbers accepted in experience field",
                                icon: Icon(
                                  Entypo.cross,
                                  color: Colors.white,
                                ),
                                backgroundColor: Colors.red),
                          );
                          return;
                        }
                        Employee emp = new Employee();
                        emp.employeeName = name;
                        emp.email = email;
                        emp.designantion = designation;
                        emp.experience = double.parse(years);
                        newEmployees.add(emp);
                        Navigator.of(contextin, rootNavigator: true)
                            .pop('dialog');
                        setState(() {
                          empYearTextEditingController.text = "";
                          empNameTextEditingController.text = "";
                          empEmailTextEditingController.text = "";
                          empDesigTextEditingController.text = "";
                        });
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  List<Widget> buildShowFirstInfoWid(Employee emp) {
    return [
      context.isMobile
          ? employeeShowField(emp)
          : Expanded(
              child: employeeShowField(emp),
            ),
      SizedBox(
        height: 5.0,
        width: 5.0,
      ),
      context.isMobile
          ? emailShowF(emp)
          : Expanded(
              child: emailShowF(emp),
            ),
    ];
  }

  Widget employeeShowField(Employee emp) {
    return showcaseCard(emp.employeeName, Icon(Feather.user));
  }

  Widget emailShowF(Employee emp) {
    return showcaseCard(emp.email, Icon(Feather.mail));
  }

  List<Widget> buildShowSecondInfoWid(Employee emp) {
    return [
      context.isMobile
          ? designShowField(emp)
          : Expanded(
              child: designShowField(emp),
            ),
      SizedBox(
        height: 5.0,
        width: 5.0,
      ),
      context.isMobile
          ? yearsShowF(emp)
          : Expanded(
              child: yearsShowF(emp),
            ),
    ];
  }

  Widget designShowField(Employee emp) {
    return showcaseCard(emp.designantion, Icon(Icons.design_services_outlined));
  }

  Widget yearsShowF(Employee emp) {
    return showcaseCard(
        emp.experience.toString() + " Years", Icon(Feather.calendar));
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
