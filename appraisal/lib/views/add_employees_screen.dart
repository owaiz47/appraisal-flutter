import 'package:appraisal/UnAuthorizedException.dart';
import 'package:appraisal/color_constants.dart';
import 'package:appraisal/components/MyToast.dart';
import 'package:appraisal/components/ToastChild.dart';
import 'package:appraisal/components/employee_add_component.dart';
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
              onPressed: () async {
                AddEmployeeWidget addEmpWidget = new AddEmployeeWidget(context);
                Employee employee = await addEmpWidget.buildShowAddFormDialog();
                if (employee != null) {
                  newEmployees.add(employee);
                  setState(() {});
                }
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
    return showcaseCard(emp.designation, Icon(Icons.design_services_outlined));
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
}
