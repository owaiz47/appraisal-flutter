class CleanJson {
  static int cleanJsonInteger(String jsonName, dynamic jsonData) {
    if (jsonData['$jsonName'] == null)
      return null;
    else if (jsonData['$jsonName'] is String) {
      if (jsonData['$jsonName'] == "") return null;
      return int.parse(jsonData['$jsonName']);
    } else
      return jsonData['$jsonName'] as int;
  }

  static double cleanJsonDouble(String jsonName, dynamic jsonData) {
    if (jsonData['$jsonName'] == null)
      return null;
    else if (jsonData['$jsonName'] is String)
      return double.parse(jsonData['$jsonName']);
    else if (jsonData['$jsonName'] is int)
      return cleanJsonInteger(jsonName, jsonData).toDouble();
    else
      return jsonData['$jsonName'] as double;
  }

  static bool cleanJsonBool(String jsonName, dynamic jsonData) {
    if (jsonData['$jsonName'] == null)
      return null;
    else if (jsonData['$jsonName'] is bool)
      return jsonData['$jsonName'];
    else if (jsonData['$jsonName'] is String) {
      int value = cleanJsonInteger(jsonName, jsonData);
      if (value == 0)
        return false;
      else
        return true;
    } else if (jsonData['$jsonName'] is int) {
      if (jsonData['$jsonName'] == 0)
        return false;
      else
        return true;
    }
  }
}
