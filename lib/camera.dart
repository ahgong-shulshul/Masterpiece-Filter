import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
        color: const Color.fromARGB(255, 247, 249, 251),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 1.3,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // 뒤로가기 버튼 -> 카메라 다시 촬영
                FloatingActionButton(
                  child: Icon(Icons.chevron_left),
                  tooltip: 'pick Iamge',
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                ),

                // 갤러리에서 이미지를 가져오는 버튼
                FloatingActionButton(
                  child: Icon(Icons.image),
                  tooltip: 'pick Iamge',
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                ),
                // 필터 적용 버튼
                FloatingActionButton(
                  child: Icon(Icons.done),
                  tooltip: 'pick Iamge',
                  onPressed: () {
                    // 필터 적용 된 사진 띄우기
                  },
                ),
              ],
            ),
            showImage(),
            SizedBox(height: 50.0),   // 나중에 필터 선택 창이 될 곳
          ],
        )
    );
  }
}

