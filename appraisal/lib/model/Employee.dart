import 'package:appraisal/helpers/CleanJson.dart';

enum ExpUnit { MONTHS, YEARS }

class Employee {
  int _id;
  String _email;
  String _employeeName;
  String _designantion;
  double _experience;
  ExpUnit _expUnit;
  double _averageRating;

  Employee();
  Employee.json2obj(this._id, this._email, this._employeeName,
      this._designantion, this._experience, this._expUnit, this._averageRating);

  factory Employee.fromJson(Map<String, dynamic> json) {
    if (json == null) return new Employee();
    return Employee.json2obj(
      CleanJson.cleanJsonInteger('id', json),
      json['email'] as String,
      json['employeeName'] as String,
      json['designantion'] as String,
      CleanJson.cleanJsonDouble('experience', json),
      getUnit(CleanJson.cleanJsonInteger('expUnit', json)),
      CleanJson.cleanJsonDouble('averageRating', json),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'email': this.email,
        'employeeName': this.employeeName,
        'designantion': this.designantion,
        'experience': this.experience,
        'expUnit': getValue(this.expUnit),
        'averageRating': this.averageRating,
      };

  static ExpUnit getUnit(int value) {
    switch (value) {
      case 0:
        return ExpUnit.MONTHS;
      default:
        return ExpUnit.YEARS;
    }
  }

  static int getValue(ExpUnit expUnit) {
    switch (expUnit) {
      case ExpUnit.MONTHS:
        return 0;
      default:
        return 1;
    }
  }

  double get averageRating => _averageRating;

  set averageRating(double value) {
    _averageRating = value;
  }

  ExpUnit get expUnit => _expUnit;

  set expUnit(ExpUnit value) {
    _expUnit = value;
  }

  double get experience => _experience;

  set experience(double value) {
    _experience = value;
  }

  String get designantion => _designantion;

  set designantion(String value) {
    _designantion = value;
  }

  String get employeeName => _employeeName;

  set employeeName(String value) {
    _employeeName = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
