import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:into_the_masterpiece/Home.dart';
import 'package:into_the_masterpiece/token_manager.dart';
import 'package:into_the_masterpiece/userpage.dart';
import 'package:path_provider/path_provider.dart';

class ShowResultPage extends StatefulWidget {
  final File? _image;
  final String? _imageName;
  const ShowResultPage(this._image, this._imageName);

  @override
  _ShowResultPageState createState() => _ShowResultPageState();

}

class _ShowResultPageState extends State<ShowResultPage> {
   String? userid;
   String? stylizedImageURl;

   TextEditingController titleController = TextEditingController();
   TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    userid = await TokenManager.loadToken();
    stylizedImageURl = "https://storage.googleapis.com/mf-stylized-images/$userid/${widget._imageName}";

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
            child: stylizedImageURl == null
                ? Text('Take Image')
                : Image.network(
              stylizedImageURl!,
            )
        ));
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

   Future<void> _uploadPost(String title, String desc) async {
     final String apiUrl = 'http://10.0.2.2:8000/feed/';

     final response = await http.post(
       Uri.parse(apiUrl),
       headers: {
         'Content-Type': 'application/json',
         'Authorization': 'Token $userid',
       },
       body: jsonEncode(
           {
              'post_title': title,
              'post_des' : desc,
              'post_image': stylizedImageURl,
           }),
     );

     if (response.statusCode == 200) {
       print('게시글 데이터 전송 성공');
       Navigator.push(
           context, MaterialPageRoute(builder: (_) => UserPage()));
     }
     else {
       print('게시글 데이터 전송 실패');
       print('HTTP Status Code: ${response.statusCode}');
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
                    Navigator.pop(context);
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
            FutureBuilder<void>(
                future: _initializeData(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return CircularProgressIndicator();
                  }
                  else{
                    if(stylizedImageURl != null) {
                      print("stylizedImageURl : $stylizedImageURl");
                      return showImage();
                    }
                    else{
                      print("stylizedUrl is null"); return Container();}
                    }
                }
            ),
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
                      if(userid == null){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("로그인이 필요한 기능입니다!"),)
                        );
                      }
                      // 사진 계정으로 업로드
                      else{
                        _showInputPostsDialog();
                      }

                    },
                  ),
                ],
              )

            ),
          ],
        )
    );
  }

   void _showInputPostsDialog() async {
     await showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           content: Column(
             children: [
               TextField(
                 controller: titleController,
                 decoration: InputDecoration(hintText: "제목: 10자 이내"),
               ),
               TextField(
                 controller: contentController,
                 decoration: InputDecoration(hintText: "내용: 10자 이내"),
               ),
             ],
           ),

           actions: [
             TextButton(
               onPressed: () {
                 Navigator.pop(context); // 다이얼로그 닫기
               },
               child: Text("취소"),
             ),
             TextButton(
               onPressed: () {
                 _uploadPost(titleController.text,
                     contentController.text); // 닉네임 업데이트 메서드 호출
                 Navigator.pop(context); // 다이얼로그 닫기
               },
               child: Text("게시"),
             ),
           ],
         );
       },
     );
   }
}

