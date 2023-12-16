import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:into_the_masterpiece/Home.dart';
import 'package:path_provider/path_provider.dart';
import './filter.dart';

class ShowResultPage extends StatefulWidget {
  final File? _image;

  const ShowResultPage(this._image);

  @override
  _ShowResultPageState createState() => _ShowResultPageState();

}

class _ShowResultPageState extends State<ShowResultPage> {
  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
        alignment: Alignment.topCenter,
        color: const Color.fromARGB(255, 247, 249, 251),
        //color: Colors.amber,
        width: MediaQuery.of(context).size.width * 0.96,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
            child: widget._image == null
                ? Text('Take Image')
                : Image.file(File(widget._image!.path))));
  }

  // 이미지를 기기에 저장하는 함수
  Future<void> saveImageToDevice() async {
    if (widget._image != null) {
      final directory = await getExternalStorageDirectory();  // 저장 경로 설정 (getExternalStorageDirectory()는 외부 저장소 경로를 제공합니다.)
      final imagePath = '${directory!.path}/my_image.jpg';

      // 이미지를 저장 경로로 복사합니다.
      await File(widget._image!.path).copy(imagePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("이미지가 기기에 저장되었습니다."),),
      );
      print("saved image to: " + imagePath);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("이미지가 없습니다."),),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // if(_image == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Error: _image is null"),),
    //   );
    // }

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 249, 251),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // 뒤로가기 버튼 -> 필터 고르는 스크린으로 이동
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new),
                  onPressed: () {
                    //필터 고르는 화면으로 이동
                  },
                ),
                Spacer(),

                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    // 임시.. 여기가 어디로 이어질지 생각하기
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage()
                        )
                    );
                  },
                ),
              ],
            ),
            showImage(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OutlinedButton.icon(
                    icon: Icon(
                      Icons.save_alt,
                      color: Colors.black54,
                    ),
                    label: Text(
                      "기기에 저장",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontFamily: "Bradley Hand ITC"
                      ),
                    ),
                    onPressed: saveImageToDevice,

                  ),

                  //SizedBox(width: 10)

                  OutlinedButton.icon(
                    icon: Icon(
                      Icons.upload,
                      color: Colors.black54,
                    ),
                    label: Text(
                      "사진 업로드",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontFamily: "Bradley Hand ITC"
                      ),
                    ),
                    onPressed: () {
                      // 사진 계정으로 업로드
                      // 로그인 유무 따져야?

                    },
                  ),
                ],
              )

            ),
          ],
        )
    );
  }
}

