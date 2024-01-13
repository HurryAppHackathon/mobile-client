import 'dart:io';
import 'package:day2/Apis/authstuf.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future UploadVideoToserver(String name, String dis, File video,File img) async {
  final url = MAINURL;
  final prefs = await SharedPreferences.getInstance();

  final token = await prefs.getString("TOKEN") ?? "";
  var request =
      new http.MultipartRequest("POST", Uri.parse("$url/api/v1/videos"));
  request.headers["Accept"] = "application/json";
  request.headers["Authorization"] = "Bearer $token";
  request.fields['name'] = name;
  request.fields['description'] = dis;
  request.fields['is_public'] = "1";
  
  request.files.add(await http.MultipartFile.fromPath('file', video.path));
  request.files.add(await http.MultipartFile.fromPath('thumbnail', img.path));
  var response = await request.send();
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  print(responseString);
  return true;
}
