import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:into_the_masterpiece/CloudApi.dart';
import 'package:into_the_masterpiece/loading.dart';
import 'package:into_the_masterpiece/login.dart';
import 'package:into_the_masterpiece/token_manager.dart';
import 'package:into_the_masterpiece/userpage.dart';
import 'package:path_provider/path_provider.dart';

import 'enumdata.dart';

class CameraExe extends StatefulWidget {
  const CameraExe({Key? key}) : super(key: key);

  @override
  _CameraExeState createState() => _CameraExeState();

}

class _CameraExeState extends State<CameraExe> {
  File? _image;
  final picker = ImagePicker();

  String? _imageName;
  Uint8List? _imageBytes;
  StyleType? _filtertype;

  late CloudApi api;

  String? token;

  @override
  void initState(){
    super.initState();
    rootBundle.loadString('assets/credentials.json').then((json) {
      api = CloudApi(json);
    });
  }

  void uploadImage(String bucketName) async {
    final response = await api.save(_imageName!, _imageBytes!, bucketName);
    print(response.downloadLink);

    token = await TokenManager.loadToken();
    // String token="test";
    if(token != null) {
      print(token);
      await api.uploadJSON(token!, _filtertype!, _imageName!, "mf-json-data");
    }
  }

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image!.path); // 가져온 이미지를 _image에 저장
      _imageBytes = _image!.readAsBytesSync();
      _imageName = _image!.path.split('/').last;
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


  ///////////// 필터 칸 ///////////////////////////////////////////

  final Map<StyleType, Image> filtersMap = {
    StyleType.scream: Image.asset("assets/the_scream.jpg", fit: BoxFit.fill),
    StyleType.rain: Image.asset("assets/rain_princess.jpg", fit: BoxFit.fill),
    StyleType.la_muse: Image.asset("assets/la_muse.jpg", fit: BoxFit.fill),
    StyleType.wreck: Image.asset("assets/the_shipwreck_of_the_minotaur.jpg", fit: BoxFit.fill),
    StyleType.udnie: Image.asset("assets/udnie.jpg", fit: BoxFit.fill),
    StyleType.wave: Image.asset("assets/wave.jpg", fit: BoxFit.fill),
  };

  Widget listview_builder(){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(2),
      itemCount: filtersMap.length,
      itemBuilder: (BuildContext context, int index){
        return InkWell(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28.0), // 원하는 둥근 정도 설정
              child: Container(
                child: filtersMap.values.toList()[index],
                width: MediaQuery.of(context).size.height * 0.2,
                padding: EdgeInsets.all(4),
              ),
            ),
            onTap: () => {
                _filtertype = filtersMap.keys.toList()[index],
                print("Selected: $_filtertype"),
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selected: $_filtertype"),),
                )
            }
        );
      },
    );
  }
  //////////////////////////////////////////////////////////////////////

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
                    if(token != null){
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
                    if(_filtertype != null){
                      uploadImage("mf-content-images");

                      // 결과창으로 이동
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoadingScreen(_image, _imageName)
                          )
                      );
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("필터를 골라주세요!"),),
                      );
                    }
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

