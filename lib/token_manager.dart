import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static Future<String?> loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }
}