import 'package:appraisal/UnAuthorizedException.dart';
import 'package:appraisal/color_constants.dart';
import 'package:appraisal/components/MyToast.dart';
import 'package:appraisal/components/ToastChild.dart';
import 'package:appraisal/components/my_text_field.dart';
import 'package:appraisal/controllers/SkillController.dart';
import 'package:appraisal/controllers/UserController.dart';
import 'package:appraisal/main.dart';
import 'package:appraisal/model/Skill.dart';
import 'package:appraisal/model/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:velocity_x/velocity_x.dart';

class AddSkillScreen extends StatefulWidget {
  @override
  _AddSkillScreenState createState() => _AddSkillScreenState();
}

class _AddSkillScreenState extends State<AddSkillScreen> {
  List<Skill> newSkills = new List<Skill>();
  TextEditingController nameTextEditingController = new TextEditingController();
  TextEditingController weightageTextEditingController =
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
          title: Text("Add New Skills"),
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
            itemCount: newSkills.length,
            itemBuilder: (context, i) {
              if (newSkills[i] == null) return SizedBox();
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
                                        buildShowFirstInfoWid(newSkills[i]),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children:
                                        buildShowFirstInfoWid(newSkills[i]),
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

  void deleteEmp(int index) {
    newSkills.removeAt(index);
    setState(() {});
  }

  void save() async {
    if (newSkills.isEmpty) {
      MyToast.showToast(
          toast: ToastChild(
              backgroundColor: Colors.red,
              icon: Icon(
                Entypo.cross,
                color: Colors.white,
              ),
              text: "No Skills Added",
              textColor: Colors.white),
          context: context);
    }
    try {
      SkillController skillController = new SkillController();
      bool saved = await skillController.saveSkills(newSkills);
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
        builder: (_) => StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  insetPadding: EdgeInsets.symmetric(horizontal: 10),
                  contentPadding: EdgeInsets.only(
                      top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
                  content: Container(
                    height: contextin.isMobile
                        ? MediaQuery.of(context).size.height * 0.5
                        : MediaQuery.of(context).size.height * 0.15,
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
                            if (!isNumeric(weightage) ||
                                int.parse(weightage) > 10) {
                              MyToast.showToast(
                                context: contextin,
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
                            Skill skill = new Skill();
                            skill.skillName = name;
                            skill.weightage = int.parse(weightage);

                            newSkills.add(skill);
                            Navigator.of(contextin, rootNavigator: true)
                                .pop('dialog');
                            setState(() {
                              nameTextEditingController.text = "";
                              weightageTextEditingController.text = "";
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
                );
              },
            ));
  }

  List<Widget> buildShowFirstInfoWid(Skill skill) {
    return [
      context.isMobile
          ? SkillNameShowField(skill)
          : Expanded(
              child: SkillNameShowField(skill),
            ),
      SizedBox(
        height: 5.0,
        width: 5.0,
      ),
      context.isMobile
          ? emailShowF(skill)
          : Expanded(
              child: emailShowF(skill),
            ),
    ];
  }

  Widget SkillNameShowField(Skill skill) {
    return showcaseCard(skill.skillName, Icon(Foundation.text_color));
  }

  Widget emailShowF(Skill skill) {
    return showcaseCard(
        skill.weightage.toString(), Icon(MaterialCommunityIcons.weight));
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
    return int.parse(s, onError: (e) => null) != null;
  }
}
