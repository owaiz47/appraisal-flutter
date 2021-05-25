import 'package:appraisal/helpers/CleanJson.dart';

class Skill {
  int _id;
  String _skillName;
  int _weightage;

  Skill();
  Skill.json2obj(this._id, this._skillName, this._weightage);

  factory Skill.fromJson(Map<String, dynamic> json) {
    if (json == null) return new Skill();
    return Skill.json2obj(
      CleanJson.cleanJsonInteger('id', json),
      json['skillName'] as String,
      CleanJson.cleanJsonInteger('weightage', json),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'skillName': this.skillName,
        'weightage': this.weightage,
      };

  int get weightage => _weightage;

  set weightage(int value) {
    _weightage = value;
  }

  String get skillName => _skillName;

  set skillName(String value) {
    _skillName = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
