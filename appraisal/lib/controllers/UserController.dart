import 'dart:convert';

import 'package:appraisal/helpers/RestHeader.dart';
import 'package:appraisal/model/AuthRequest.dart';
import 'package:appraisal/model/User.dart';
import 'package:appraisal/repository/UserStorage.dart';
import 'package:appraisal/url_constants.dart';
import 'package:http/http.dart' as http;

import '../UnAuthorizedException.dart';

class UserController {
  Future<bool> login(AuthRequest authRequest) async {
    try {
      String url = "$api_url/authenticate";
      var jso = jsonEncode(authRequest);
      Uri uri = Uri.parse(url);
      final response = await http
          .post(uri, body: jso, headers: {"content-type": "application/json"});

      if (response.statusCode == 200 || response.statusCode == 201) {
        token = jsonDecode(response.body)['token'];
        Uri u = Uri.parse("$api_url/authenticated_user");
        final userRes =
            await http.get(u, headers: RestHeader.getRestHearders());
        if (userRes.statusCode == 401 || userRes.statusCode == 403) {
          return false;
        }
        authenticatedUser = User.fromJson(jsonDecode(userRes.body));
        return true;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return false;
      } else {
        throw Exception('Something went wrong.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<User>> getUsers() async {
    List<User> users;
    String url = "$api_url/users";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: RestHeader.getRestHearders());

    if (response.statusCode == 200 || response.statusCode == 201) {
      var json = jsonDecode(response.body);
      if (users == null) users = new List<User>();
      for (var js in json) {
        User emp = User.fromJson(js);
        users.add(emp);
      }
      return users;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      token = null;
      authenticatedUser = null;
      throw UnAuthorizedException("Session Expired");
    } else {
      throw Exception('Something went wrong.');
    }
  }

  Future<bool> saveUser(User user) async {
    String url = "$api_url/users/user";
    Uri uri = Uri.parse(url);
    var jss = jsonEncode(user);
    final response =
        await http.post(uri, body: jss, headers: RestHeader.getRestHearders());

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

  Future<bool> saveUsers(List<User> users) async {
    String url = "$api_url/users";
    Uri uri = Uri.parse(url);
    var jss = jsonEncode(users);
    final response =
        await http.post(uri, body: jss, headers: RestHeader.getRestHearders());

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

  Future<bool> deleteUser(User user) async {
    String url = "$api_url/users/del/${user.id}";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: RestHeader.getRestHearders());

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

  Future<List<User>> getUsersByName(String name) async {
    List<User> users;
    String url = "$api_url/users/name/$name";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: RestHeader.getRestHearders());

    if (response.statusCode == 200 || response.statusCode == 201) {
      var json = jsonDecode(response.body);
      if (users == null) users = new List<User>();
      for (var js in json) {
        User emp = User.fromJson(js);
        users.add(emp);
      }
      return users;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      token = null;
      authenticatedUser = null;
      throw UnAuthorizedException("Session Expired");
    } else {
      throw Exception('Something went wrong.');
    }
  }
}
