import 'package:appraisal/model/Employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:velocity_x/velocity_x.dart';

import '../color_constants.dart';
import 'MyToast.dart';
import 'ToastChild.dart';
import 'my_text_field.dart';

class AddEmployeeWidget {
  final BuildContext context;
  Employee employee;

  AddEmployeeWidget(this.context, {this.employee});

  TextEditingController empNameTextEditingController =
      new TextEditingController();
  TextEditingController empEmailTextEditingController =
      new TextEditingController();
  TextEditingController empDesigTextEditingController =
      new TextEditingController();
  TextEditingController empYearTextEditingController =
      new TextEditingController();
  Future<Employee> buildShowAddFormDialog() {
    if (employee != null) {
      empNameTextEditingController.text = employee.employeeName;
      empEmailTextEditingController.text = employee.email;
      empDesigTextEditingController.text = employee.designation;
      empYearTextEditingController.text = employee.experience.toString();
    }
    return showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, _) {
              return AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 10),
                contentPadding: EdgeInsets.only(
                    top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
                content: Container(
                  height: context.isMobile
                      ? MediaQuery.of(context).size.height * 0.7
                      : MediaQuery.of(context).size.height * 0.25,
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
                                    children: _buildFirstInfoWid(),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: _buildFirstInfoWid(),
                                  ),
                            SizedBox(
                              height: 5.0,
                            ),
                            context.isMobile
                                ? Column(
                                    children: _buildSecondInfoWid(),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: _buildSecondInfoWid(),
                                  )
                          ],
                        ),
                      ),
                      RaisedButton(
                        color: Color(k_blue_color),
                        onPressed: () {
                          String name = empNameTextEditingController.text;
                          String email = empEmailTextEditingController.text;
                          String designation =
                              empDesigTextEditingController.text;
                          String years = empYearTextEditingController.text;
                          if (name.replaceAll(" ", "").isEmpty ||
                              email.replaceAll(" ", "").isEmpty ||
                              designation.replaceAll(" ", "").isEmpty ||
                              years.replaceAll(" ", "").isEmpty) {
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
                          if (!isNumeric(years)) {
                            MyToast.showToast(
                              context: context,
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
                            return null;
                          }
                          if (employee == null) employee = new Employee();
                          employee.employeeName = name;
                          employee.email = email;
                          employee.designation = designation;
                          employee.experience = double.parse(years);
                          //newEmployees.add(emp);
                          /*Navigator.of(context, rootNavigator: true)
                            .pop('dialog');*/
                          Navigator.pop(context, employee);
                          return employee;
                        },
                        child: Text(
                          employee != null ? "Save" : "Add",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

  List<Widget> _buildFirstInfoWid({readOnly = false}) {
    return [
      context.isMobile
          ? _employeeTextField(readonly: readOnly)
          : Expanded(
              child: _employeeTextField(readonly: readOnly),
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

  MyTextField _employeeTextField({bool readonly = false}) {
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

  _buildSecondInfoWid({readOnly = false}) {
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

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
}
