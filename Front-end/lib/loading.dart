import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:into_the_masterpiece/showResult.dart';
import 'dart:io';

class LoadingScreen extends StatelessWidget {
  final File? _image;
  final String? _imageName;
  const LoadingScreen(this._image, this._imageName);

  @override
  Widget build(BuildContext context) {
    print("enter Loading Screen");
    print("넘어온 이미지: $_image / 넘어온 이미지이름: $_imageName");

    // 로딩이 완료되면 navigateToNextPage 함수를 호출하여 다음 페이지로 이동
    Future.delayed(Duration(seconds: 60), () {
      navigateToNextPage(context);
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // 중앙 정렬
        elevation: 0.0,
        backgroundColor: Colors.white,

        title: Image.asset('assets/titleLogo.png'),

      ),
      body: Center(
        //로딩바 구현 부분
        child: SpinKitFadingCube( // FadingCube 모양 사용
          color: Colors.black, // 색상 설정
          size: 50.0, // 크기 설정
          duration: Duration(seconds: 3), //속도 설정
        ),
      ),
    );
  }

  // 다음 페이지로 이동하는 함수
  void navigateToNextPage(BuildContext context) {
    // 예를 들어, MaterialPageRoute을 사용하여 새로운 화면으로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ShowResultPage(_image,_imageName)),
    );
  }
}