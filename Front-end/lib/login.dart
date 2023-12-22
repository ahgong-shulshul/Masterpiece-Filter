import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:into_the_masterpiece/Home.dart';
import 'package:into_the_masterpiece/token_manager.dart';
import 'package:into_the_masterpiece/userpage.dart';
import 'enumdata.dart';

class LoginExe extends StatefulWidget{
  const LoginExe({Key? key}) :super(key: key);

  @override
  State<LoginExe> createState() => _LoginExeState();
}

class _LoginExeState extends State<LoginExe> {
  LoginPlatform _loginPlatform = LoginPlatform.none;

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');

      // http 객체로 Django에 유저 이메일 전송
      await sendEmailAndReceiveToken(googleUser.email);


      setState(() {
        _loginPlatform = LoginPlatform.google;
      });
    }
  }

  void signInWithNaver() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      print('accessToken = ${result.accessToken}');
      print('id = ${result.account.id}');
      print('email = ${result.account.email}');
      print('name = ${result.account.name}');

      sendEmailAndReceiveToken(result.account.email);

      setState(() {
        _loginPlatform = LoginPlatform.naver;
      });
    }
  }

  Future<void> sendEmailAndReceiveToken(String email) async {
    final String apiUrl = 'http://10.0.2.2:8000/customuser/social-login/';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      print('이메일 데이터 전송 성공');
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData['token'];

      await TokenManager.saveToken(token);
      print('토큰: $token');
    }
    else {
      print('이메일 데이터 전송 실패');
      print('HTTP Status Code: ${response.statusCode}');
    }
  }

  void signOut() async {
    print('_loginPlatform before signOut: $_loginPlatform'); // 디버깅용 출력

    switch (_loginPlatform) {
      case LoginPlatform.google:
        await GoogleSignIn().signOut();
        _loginPlatform = LoginPlatform.none;
        TokenManager.deleteToken();
        print("logout");
        break;
      case LoginPlatform.kakao:
        break;
      case LoginPlatform.naver:
        break;
      case LoginPlatform.none:
        break;
    }

    print('_loginPlatform after signOut: $_loginPlatform');

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: _loginPlatform != LoginPlatform.none
              ? ForLoggedInUser()
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                  ),
                  SizedBox(width: 30),

                  _loginButton(
                    'assets/google.png',
                    signInWithGoogle,
                  ),

                  SizedBox(width: 30),

                  _loginButton(
                    'assets/naver.png',
                    signInWithNaver,
                  ),

                  SizedBox(height: 30),
                 // _logoutButton(),
                ],
              )),
    );
  }

  Widget ForLoggedInUser() {
    return UserPage();
  }

  Widget _loginButton(String path, VoidCallback onTap) {
    return Card(
      elevation: 5.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage(path),
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(35.0),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: signOut,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color(0xff0165E1),
        ),
      ),
      child: const Text('로그아웃'),
    );
  }
}

