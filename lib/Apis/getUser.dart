import 'package:day2/Apis/urlAPI.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String url = APIurl;
const String MAINURL = APIurl;
Future getUserData() async {
  final prefs = await SharedPreferences.getInstance();

  final token = await prefs.getString("TOKEN") ?? "";

  final response = await http.get(
    Uri.parse("$url/api/v1/auth/@me"),
    headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    return null;
  }
}
