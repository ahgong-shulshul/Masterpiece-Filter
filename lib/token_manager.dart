import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static Future<String?> loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();    // 토큰을 SharedPreferences에 저장. 이미 인스턴스가 생성된 상태면 그 인스턴스 사용. 아니면 새로 생성함
    prefs.setString('token', token);
  }
}