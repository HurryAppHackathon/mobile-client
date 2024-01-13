import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String url = "http://172.20.10.6:40000";
const String MAINURL = "http://172.20.10.6:40000";
Future getListOFpartys() async {
  final prefs = await SharedPreferences.getInstance();

  final token = await prefs.getString("TOKEN") ?? "";
  
  final response = await http.get(
    Uri.parse("$url/api/v1/parties?type=public&status=ongoing"),
    headers: {
      
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return false;
  }
}