import 'package:appraisal/repository/UserStorage.dart';

class RestHeader {
  static Map<String, String> getRestHearders() {
    String auth_header = 'Bearer ' + token;

    Map<String, String> headers = {
      "content-type": "application/json",
      "accept": "application/json",
      "authorization": auth_header
    };

    return headers;
  }
}
