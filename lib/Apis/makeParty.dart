
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String url = "http://172.20.10.6:40000";
const String MAINURL = "http://172.20.10.6:40000";

Future MakeParty(String name) async {
  final prefs = await SharedPreferences.getInstance();

  final token = await prefs.getString("TOKEN") ?? "";
  final response = await http.post(
    Uri.parse("$url/api/v1/parties"),
    headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    body: {"name": name, "is_public": "1"},
  );
 
  if (response.statusCode == 200) {
   
    return true;
  } else {
    return response.body;
  }
}
