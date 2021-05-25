import 'dart:convert';

import 'package:appraisal/UnAuthorizedException.dart';
import 'package:appraisal/helpers/RestHeader.dart';
import 'package:appraisal/model/Employee.dart';
import 'package:appraisal/repository/UserStorage.dart';
import 'package:http/http.dart' as http;
import '../url_constants.dart';

class EmployeeController {
  Future<Employee> getEmployee(int id) async {
    Employee emp;
    String url = "$api_url/employees/id/$id";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: RestHeader.getRestHearders());

    if (response.statusCode == 200 || response.statusCode == 201) {
      emp = Employee.fromJson(jsonDecode(response.body));
      return emp;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      token = null;
      authenticatedUser = null;
      throw UnAuthorizedException("Session Expired");
    } else {
      throw Exception('Something went wrong.');
    }
  }

  Future<List<Employee>> getEmployees() async {
    List<Employee> employees;
    String url = "$api_url/employees";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: RestHeader.getRestHearders());

    if (response.statusCode == 200 || response.statusCode == 201) {
      var json = jsonDecode(response.body);
      if (employees == null) employees = new List<Employee>();
      for (var js in json) {
        Employee emp = Employee.fromJson(js);
        employees.add(emp);
      }
      return employees;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      token = null;
      authenticatedUser = null;
      throw UnAuthorizedException("Session Expired");
    } else {
      throw Exception('Something went wrong.');
    }
  }

  Future<List<Employee>> getEmployeesByName(String name) async {
    List<Employee> employees;
    String url = "$api_url/employees/name/$name";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri, headers: RestHeader.getRestHearders());

    if (response.statusCode == 200 || response.statusCode == 201) {
      var json = jsonDecode(response.body);
      if (employees == null) employees = new List<Employee>();
      for (var js in json) {
        Employee emp = Employee.fromJson(js);
        employees.add(emp);
      }
      return employees;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      token = null;
      authenticatedUser = null;
      throw UnAuthorizedException("Session Expired");
    } else {
      throw Exception('Something went wrong.');
    }
  }

  Future<bool> saveEmployee(Employee employee) async {
    Employee emp;
    String url = "$api_url/employees/employee";
    Uri uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(employee), headers: RestHeader.getRestHearders());

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

  Future<bool> saveEmployees(List<Employee> employees) async {
    Employee emp;
    String url = "$api_url/employees";
    Uri uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(employees), headers: RestHeader.getRestHearders());

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

  Future<bool> deleteEmployee(Employee employee) async {
    Employee emp;
    String url = "$api_url/employees/${employee.id}";
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
}
