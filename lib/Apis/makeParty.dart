
import 'package:day2/Apis/urlAPI.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String url = APIurl;
const String MAINURL = APIurl;

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
