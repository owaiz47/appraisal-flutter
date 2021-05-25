import 'package:appraisal/model/Skill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:velocity_x/velocity_x.dart';

import '../color_constants.dart';
import 'MyToast.dart';
import 'ToastChild.dart';
import 'my_text_field.dart';

class AddSkillWidget {
  final BuildContext context;
  Skill skill;

  AddSkillWidget(this.context, {this.skill});

  TextEditingController nameTextEditingController = new TextEditingController();
  TextEditingController weightageTextEditingController =
      new TextEditingController();

  Future<Skill> buildShowAddFormDialog() {
    if (skill != null) {
      nameTextEditingController.text = skill.skillName;
      weightageTextEditingController.text = skill.weightage.toString();
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
                        ? MediaQuery.of(context).size.height * 0.5
                        : MediaQuery.of(context).size.height * 0.15,
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
                            ],
                          ),
                        ),
                        RaisedButton(
                          color: Color(k_blue_color),
                          onPressed: () {
                            String name = nameTextEditingController.text;
                            String weightage =
                                weightageTextEditingController.text;
                            if (name.replaceAll(" ", "").isEmpty ||
                                weightage.replaceAll(" ", "").isEmpty) {
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
                              return;
                            }
                            if (!isNumeric(weightage) ||
                                int.parse(weightage) > 10) {
                              MyToast.showToast(
                                context: context,
                                toast: ToastChild(
                                    textColor: Colors.white,
                                    text:
                                        "Weightage can only be an integer and less than or equal to 10",
                                    icon: Icon(
                                      Entypo.cross,
                                      color: Colors.white,
                                    ),
                                    backgroundColor: Colors.red),
                              );
                              return;
                            }
                            if (skill == null) skill = new Skill();
                            skill.skillName = name;
                            skill.weightage = int.parse(weightage);

                            /*newSkills.add(skill);
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');*/
                            Navigator.pop(context, skill);
                            setState(() {
                              nameTextEditingController.text = "";
                              weightageTextEditingController.text = "";
                            });
                          },
                          child: Text(
                            skill != null ? "Save" : "Add",
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
          ? SkillNameTextField(readonly: readOnly)
          : Expanded(
              child: SkillNameTextField(readonly: readOnly),
            ),
      SizedBox(
        height: 5.0,
        width: 5.0,
      ),
      context.isMobile
          ? WeightageTF(readonly: readOnly)
          : Expanded(
              child: WeightageTF(readonly: readOnly),
            ),
    ];
  }

  MyTextField SkillNameTextField({bool readonly = false}) {
    return MyTextField(
      readOnly: readonly,
      icon: Icon(Foundation.text_color),
      controller: nameTextEditingController,
      showLabel: false,
      hint: "Name Of The Skill",
    );
  }

  MyTextField WeightageTF({bool readonly = false}) {
    return MyTextField(
      readOnly: readonly,
      icon: Icon(MaterialCommunityIcons.weight),
      controller: weightageTextEditingController,
      showLabel: false,
      hint: "Weightage (0-10)",
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.parse(s, onError: (e) => null) != null;
  }
}
