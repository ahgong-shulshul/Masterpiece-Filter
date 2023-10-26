import 'package:flutter/material.dart';
import 'package:into_the_masterpiece/camera.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 249, 251),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
            // 사진 촬영으로 이동하는 버튼
            FloatingActionButton.extended(
              heroTag: 'camera',
              icon: Icon(
                      Icons.photo_camera,
                      color: Colors.black,
                    ),
              label: Text(
                  "Photo",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "Bradley Hand ITC"
                    ),
                  ),
              backgroundColor: Color.fromARGB(255, 247, 249, 251),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => CameraExe()));
              },
            ),
            SizedBox(height: 40),
            // 갤러리에서 이미지를 가져오는 버튼
            FloatingActionButton.extended(
              heroTag: 'gallery',
              icon: Icon(
                  Icons.image,
                  color: Colors.black,
                  ),
              label: Text(
                  "Gallery",
                   style: TextStyle(
                     color: Colors.black,
                     fontSize: 18,
                     fontFamily: "Bradley Hand ITC"
                      ),
              ),
              backgroundColor: Color.fromARGB(255, 247, 249, 251),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => CameraExe()));
              },
            ),
            SizedBox(height: 40),
            // 로그인으로 이동하는 버튼
            FloatingActionButton.extended(
              heroTag: 'login',
              icon: Icon(
                Icons.login,
                color: Colors.black,
              ),
              label: Text(
                  "Login",
                   style: TextStyle(
                     color: Colors.black,
                     fontSize: 18,
                     fontFamily: "Bradley Hand ITC"
                  ),
              ),
              backgroundColor: Color.fromARGB(255, 247, 249, 251),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => CameraExe()));
              },
            ),
          ]
        )
      ),
    );
  }
}