import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:into_the_masterpiece/showResult.dart';
import './filter.dart';

class CameraExe extends StatefulWidget {
  const CameraExe({Key? key}) : super(key: key);

  @override
  _CameraExeState createState() => _CameraExeState();

}

class _CameraExeState extends State<CameraExe> {
  File? _image;
  final picker = ImagePicker();

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image!.path); // 가져온 이미지를 _image에 저장
    });

  }

  void changeImage(File img) async{
    final image = img;
    setState(() {
      _image = File(image!.path);
    });
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
        alignment: Alignment.topCenter,
        color: const Color.fromARGB(255, 247, 249, 251),
        //color: Colors.amber,
        width: MediaQuery.of(context).size.width * 0.96,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
            child: _image == null
                ? Text('Take Image')
                : Image.file(File(_image!.path))));
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    if(_image == null) getImage(ImageSource.camera);

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 249, 251),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // 뒤로가기 버튼 -> 카메라 다시 촬영
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new),
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                ),
                Spacer(),
                // // 갤러리에서 이미지를 가져오는 버튼
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                ),
                Spacer(),

                // 사용자 계정으로 이동하는 버튼
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    // 사용자 계정으로 이동(로그인 유무 생각)
                    // Navigator.push(
                    //   context, MaterialPageRoute(builder: (context) => const NextScreen()),
                    // );
                  },
                ),
                Spacer(),
                // 필터 적용 버튼
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    // 결과창으로 이동
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowResultPage(_image)
                        )
                    );
                  },
                ),
              ],
            ),
            showImage(),
            Container(
              color: Color.fromARGB(255, 247, 249, 251),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.all(2),
              child: listview_builder(),

            ),   // 나중에 필터 선택 창이 될 곳
          ],
        )
    );
  }
}

