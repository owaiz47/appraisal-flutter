import 'package:appraisal/helpers/CleanJson.dart';
import 'package:appraisal/model/Employee.dart';
import 'package:appraisal/model/Skill.dart';
import 'package:appraisal/model/User.dart';

import 'Skill.dart';

class Rating {
  int _id;
  User _ratedBy;
  Employee _employee;
  Skill _skill;
  double _rating;

  Rating();
  Rating.json2obj(
      this._id, this._rating, this._ratedBy, this._employee, this._skill);

  factory Rating.fromJson(Map<String, dynamic> json) {
    if (json == null) return new Rating();
    return Rating.json2obj(
      CleanJson.cleanJsonInteger('id', json),
      CleanJson.cleanJsonDouble('rating', json),
      User.fromJson(json['ratedBy'] as Map<String, dynamic>),
      Employee.fromJson(json['employee'] as Map<String, dynamic>),
      Skill.fromJson(json['skill'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'rating': this._rating,
        'ratedBy': this._ratedBy,
        'employee': this._employee,
        'skill': this._skill
      };

  Skill get skill => _skill;

  set skill(Skill value) {
    _skill = value;
  }

  Employee get employee => _employee;

  set employee(Employee value) {
    _employee = value;
  }

  User get ratedBy => _ratedBy;

  set ratedBy(User value) {
    _ratedBy = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  double get rating => _rating;

  set rating(double value) {
    _rating = value;
  }
}
