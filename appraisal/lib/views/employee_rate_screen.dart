import 'package:appraisal/components/MyToast.dart';
import 'package:appraisal/components/ToastChild.dart';
import 'package:appraisal/controllers/RatingController.dart';
import 'package:appraisal/controllers/SkillController.dart';
import 'package:appraisal/main.dart';
import 'package:appraisal/model/Employee.dart';
import 'package:appraisal/model/Rating.dart';
import 'package:appraisal/model/Skill.dart';
import 'package:appraisal/repository/UserStorage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../UnAuthorizedException.dart';

class EmployeeRateScreen extends StatefulWidget {
  final Employee employee;

  const EmployeeRateScreen({Key key, this.employee}) : super(key: key);
  @override
  _EmployeeRateScreenState createState() => _EmployeeRateScreenState(employee);
}

class _EmployeeRateScreenState extends State<EmployeeRateScreen> {
  final Employee employee;
  List<Rating> ratings;
  List<Skill> skills;
  _EmployeeRateScreenState(this.employee);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetcMyRatingsForEmp();
    fetchSkills();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _back,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _back,
            ),
            title: Text("Rate ${employee.employeeName}"),
            actions: [
              FlatButton(
                  onPressed: () {
                    save();
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          body: ratings == null
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : (ratings.isEmpty
                  ? Container(
                      child: Center(
                        child: Text(
                          "No SKills Added To Rate",
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: ratings.length,
                      itemBuilder: (context, i) {
                        return Card(
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(child: Text("#${i + 1}")),
                                Expanded(
                                    child: Text(ratings[i].skill.skillName)),
                                Expanded(
                                    child: Text(ratings[i].rating.toString())),
                                Expanded(
                                  flex: 2,
                                  child: RatingBar.builder(
                                    itemBuilder: (context, i) {
                                      return Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      );
                                    },
                                    unratedColor: Colors.black,
                                    allowHalfRating: true,
                                    onRatingUpdate: (rate) {
                                      setState(() {
                                        ratings[i].rating = rate;
                                      });
                                    },
                                    itemCount: 10,
                                    initialRating: ratings[i].rating,
                                    itemSize: 30.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
        ));
  }

  Future<bool> _back() async {
    Navigator.pop(context, false);
    return false;
  }

  void fetchSkills() async {
    setState(() {
      skills = null;
    });
    try {
      SkillController skillController = new SkillController();
      skills = await skillController.getSkills();
      if (skills == null) throw Exception("wrong");
      ratings = new List<Rating>();
      for (Skill s in skills) {
        Rating r = new Rating();
        r.skill = s;
        r.ratedBy = authenticatedUser;
        r.employee = employee;
        r.rating = 0;
        ratings.add(r);
      }
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

  void fetcMyRatingsForEmp() async {
    setState(() {
      ratings = null;
      skills = null;
    });
    fetchSkills();
    try {
      RatingController ratingController = new RatingController();
      ratings = await ratingController.getMyRatingsForEmployee(employee.id);
      SkillController skillController = new SkillController();
      skills = await skillController.getSkills();
      if (skills == null) throw Exception("wrong");
      if (ratings == null) ratings = new List<Rating>();
      for (Skill s in skills) {
        if (!skillInRatings(s)) {
          Rating r = new Rating();
          r.skill = s;
          r.ratedBy = authenticatedUser;
          r.employee = employee;
          r.rating = 0;
          ratings.add(r);
        }
      }
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

  void save() async {
    if (ratings.isEmpty) {
      MyToast.showToast(
          toast: ToastChild(
              backgroundColor: Colors.red,
              icon: Icon(
                Entypo.cross,
                color: Colors.white,
              ),
              text: "No Ratings Added",
              textColor: Colors.white),
          context: context);
    }
    try {
      RatingController ratingController = new RatingController();
      bool saved = await ratingController.saveRatings(ratings);
      if (saved == null || !saved) {
        MyToast.somethingWentWrong(context);
        return;
      }
      MyToast.showToast(
          toast: ToastChild(
              backgroundColor: Colors.greenAccent,
              icon: Icon(
                Entypo.check,
                color: Colors.white,
              ),
              text: "Employee Rating Updated",
              textColor: Colors.white),
          context: context);
      Navigator.pop(context, true);
    } on UnAuthorizedException catch (e) {
      MyToast.showSessionExpired(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyApp()));
    } catch (e) {
      MyToast.somethingWentWrong(context);
    }
  }

  skillInRatings(Skill s) {
    for (Rating r in ratings) {
      if (r.skill.id == s.id) return true;
    }
    return false;
  }
}
