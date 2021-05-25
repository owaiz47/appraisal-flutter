import 'dart:convert';

import 'package:appraisal/UnAuthorizedException.dart';
import 'package:appraisal/helpers/RestHeader.dart';
import 'package:appraisal/model/Employee.dart';
import 'package:appraisal/model/Skill.dart';
import 'package:appraisal/repository/UserStorage.dart';
import 'package:http/http.dart' as http;
import '../url_constants.dart';

class SkillController {
  Future<List<Skill>> getSkills() async {
    List<Skill> skills;
    String url = "$api_url/skills";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: RestHeader.getRestHearders());

    if (response.statusCode == 200 || response.statusCode == 201) {
      var json = jsonDecode(response.body);
      if (skills == null) skills = new List<Skill>();
      for (var js in json) {
        Skill skill = Skill.fromJson(js);
        skills.add(skill);
      }
      return skills;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      token = null;
      authenticatedUser = null;
      throw UnAuthorizedException("Session Expired");
    } else {
      throw Exception('Something went wrong.');
    }
  }

  Future<bool> saveSkills(List<Skill> skills) async {
    String url = "$api_url/skills";
    Uri uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(skills), headers: RestHeader.getRestHearders());

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      token = null;
      authenticatedUser = null;
      throw UnAuthorizedException("Session Expired");
    } else {
      throw Exception('Something went wrong.');
    }
  }

  Future<bool> deleteSkill(Skill skill) async {
    Skill sk;
    String url = "$api_url/skills/${skill.id}";
    Uri uri = Uri.parse(url);
    final response =
        await http.delete(uri, headers: RestHeader.getRestHearders());

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      token = null;
      authenticatedUser = null;
      throw UnAuthorizedException("Session Expired");
    } else {
      throw Exception('Something went wrong.');
    }
  }

  Future<List<Skill>> getSkillsByName(String name) async {
    List<Skill> skills;
    String url = "$api_url/skills/$name";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: RestHeader.getRestHearders());

    if (response.statusCode == 200 || response.statusCode == 201) {
      var json = jsonDecode(response.body);
      if (skills == null) skills = new List<Skill>();
      for (var js in json) {
        Skill skill = Skill.fromJson(js);
        skills.add(skill);
      }
      return skills;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      token = null;
      authenticatedUser = null;
      throw UnAuthorizedException("Session Expired");
    } else {
      throw Exception('Something went wrong.');
    }
  }
}
