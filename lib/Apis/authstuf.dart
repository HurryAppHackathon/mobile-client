import 'dart:convert';
import 'package:http/http.dart' as http;
const String url ="http://172.20.10.6:40000";
Future login(String username,String password) async {
  final response = await http.post(
    Uri(path: "$url/api/v1/auth/login"),
    
    body: jsonEncode(<String, String>{
    "username": username,
    "password": password
}),
  );

  return response.body;
}
Future register(String username,String password,String email) async {
  final response = await http.post(
    Uri(path: "$url/api/v1/auth/register"),
    
    body: jsonEncode(<String, String>{
    "username": username,
    "email": email,
    "password": password
}),
  );

  return response.body;
}

