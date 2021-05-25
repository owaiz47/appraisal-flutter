import 'package:appraisal/UnAuthorizedException.dart';
import 'package:appraisal/color_constants.dart';
import 'package:appraisal/components/MyToast.dart';
import 'package:appraisal/components/ToastChild.dart';
import 'package:appraisal/components/add_skill_component.dart';
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
              onPressed: () async {
                AddSkillWidget addWid = new AddSkillWidget(context);
                Skill skill = await addWid.buildShowAddFormDialog();
                if (skill != null) {
                  newSkills.add(skill);
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
}
