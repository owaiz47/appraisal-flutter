import 'dart:convert';

import 'package:appraisal/UnAuthorizedException.dart';
import 'package:appraisal/helpers/RestHeader.dart';
import 'package:appraisal/model/Employee.dart';
import 'package:appraisal/model/Rating.dart';
import 'package:appraisal/model/Skill.dart';
import 'package:appraisal/repository/UserStorage.dart';
import 'package:http/http.dart' as http;
import '../url_constants.dart';

class RatingController {
  Future<List<Rating>> getMyRatingsForEmployee(int id) async {
    List<Rating> ratings;
    String url = "$api_url/ratings/${authenticatedUser.id}/$id";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: RestHeader.getRestHearders());

    if (response.statusCode == 200 || response.statusCode == 201) {
      var json = jsonDecode(response.body);
      if (ratings == null) ratings = new List<Rating>();
      for (var js in json) {
        Rating rating = Rating.fromJson(js);
        ratings.add(rating);
      }
      return ratings;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      token = null;
      authenticatedUser = null;
      throw UnAuthorizedException("Session Expired");
    } else {
      throw Exception('Something went wrong.');
    }
  }

  Future<bool> saveRatings(List<Rating> ratings) async {
    String url = "$api_url/ratings";
    Uri uri = Uri.parse(url);
    var j = jsonEncode(ratings);
    final response =
        await http.post(uri, body: j, headers: RestHeader.getRestHearders());

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

  Future<Skill> deleteEmployee(Skill skill) async {
    Skill sk;
    String url = "$api_url/skills/${skill.id}";
    Uri uri = Uri.parse(url);
    final response =
        await http.delete(uri, headers: RestHeader.getRestHearders());

    if (response.statusCode == 200 || response.statusCode == 201) {
      sk = Skill.fromJson(jsonDecode(response.body));
      return sk;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      token = null;
      authenticatedUser = null;
      throw UnAuthorizedException("Session Expired");
    } else {
      throw Exception('Something went wrong.');
    }
  }
}
