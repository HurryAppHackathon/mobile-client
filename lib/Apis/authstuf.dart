import 'dart:convert';

import 'package:day2/Apis/urlAPI.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String url = APIurl;
const String MAINURL = APIurl;
Future loginwithToken() async {
  final prefs = await SharedPreferences.getInstance();

  final token = await prefs.getString("TOKEN") ?? "";

  final response = await http.get(
    Uri.parse("$url/api/v1/auth/@me"),
    headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
  );
  print(token);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return false;
  }
}

Future login(String username, String password) async {
  final response = await http.post(
    Uri.parse("$url/api/v1/auth/login/"),
    headers: {"Accept": "application/json"},
    body: {"username": username, "password": password},
  );
  if (response.statusCode == 200) {
    final prefs = await SharedPreferences.getInstance();

    final token = jsonDecode(response.body)["data"]["token"];

    await prefs.setString("TOKEN", token);
    return true;
  } else {
    return response.body;
  }
}

Future register(String username, String password, String email, String fName,
    String sName) async {
  final response =
      await http.post(Uri.parse("$url/api/v1/auth/register"), headers: {
    "Accept": "application/json"
  }, body: {
    "first_name": fName,
    "last_name": sName,
    "username": username,
    "email": email,
    "password": password
  });
  if (response.statusCode == 200) {
    final prefs = await SharedPreferences.getInstance();

    final token = jsonDecode(response.body)["data"]["token"];
    
    await prefs.setString("TOKEN", token);
    return true;
  } else {
    
    return response.body;
  }
}
