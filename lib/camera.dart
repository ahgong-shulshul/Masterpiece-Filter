import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:into_the_masterpiece/login.dart';
import 'package:into_the_masterpiece/showResult.dart';
import 'package:into_the_masterpiece/token_manager.dart';
import 'package:into_the_masterpiece/userpage.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/storage/v1.dart' as storage;
import 'package:path_provider/path_provider.dart';

class CameraExe extends StatefulWidget {
  const CameraExe({Key? key}) : super(key: key);

  @override
  _CameraExeState createState() => _CameraExeState();

}

class _CameraExeState extends State<CameraExe> {
  File? _image;
  final picker = ImagePicker();
  File? _UploadImage;
  late int filterNum;

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image!.path); // 가져온 이미지를 _image에 저장
    });

  }

  void changeImage(String imgPath) async{
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/monkafter.jpg';

    setState(() {
      _image = File(filePath);
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


  // 스토리지에 이미지 업로드
  Future<String> uploadImage(File imageFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;   // 파이어베이스 스토리지 인스턴스 가져옴
    Reference ref = storage.ref().child('mf-content-images');  // 업로드할 이미지 경로 저장

    UploadTask uploadTask = ref.putFile(imageFile); //파일 업로드. 비동기로 작동
    TaskSnapshot storageTaskSnapshot = await uploadTask;  // 업로드 될때까지 대기, 완료되면 업로드된 파일 정보를 포함하는 TaskSnapshot을 가져옴
    String downloadURL = await storageTaskSnapshot.ref.getDownloadURL();  //업로드된 파일의 다운로드 URL
    return downloadURL;
  }





  ///////////// 필터 칸 ///////////////////////////////////////////
  final List<Image> filters = <Image>[
    Image.asset("assets/monk.jpg", fit: BoxFit.fill,),
    Image.asset("assets/splash.png", fit: BoxFit.fill,),
    Image.asset("assets/tmp2.png", fit: BoxFit.fill,),
    Image.asset("assets/tmp4.png", fit: BoxFit.fill,),
    Image.asset("assets/tmp1.png", fit: BoxFit.fill,),
    Image.asset("assets/splash.png", fit: BoxFit.fill,),
    Image.asset("assets/tmp3.png", fit: BoxFit.fill,),
    Image.asset("assets/tmp4.png", fit: BoxFit.fill,)];

  Widget listview_builder(){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(2),
      itemCount: filters.length,
      itemBuilder: (BuildContext context, int index){
        return InkWell(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28.0), // 원하는 둥근 정도 설정
              child: Container(
                child: filters[index],
                width: MediaQuery.of(context).size.height * 0.2,
                padding: EdgeInsets.all(4),
              ),
            ),
            onTap: () => {
                filterNum = index,
                print(filterNum),
             //   changeImage('assets/monkafter.jpg')
            }
        );
      },
    );
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
                    if(TokenManager.loadToken() != null){
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) => UserPage()),
                      );
                    }
                    else{
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) => LoginExe()),
                      );
                    }

                  },
                ),
                Spacer(),

                // 필터 적용 버튼
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    // 스토리지에 필터 인덱스와 함께 사진 업로드
                    uploadImage(_image!);

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

