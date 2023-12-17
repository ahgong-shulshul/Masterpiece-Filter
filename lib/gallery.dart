import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:into_the_masterpiece/showResult.dart';
import 'package:path_provider/path_provider.dart';

class GalleryExe extends StatefulWidget {
  const GalleryExe({Key? key}) : super(key: key);

  @override
  _GalleryExeState createState() => _GalleryExeState();

}

class _GalleryExeState extends State<GalleryExe> {
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

  void changeImage(String imgPath) async{
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/AfterImg2.jpg';

    setState(() {
      _image = File(filePath);
    });
  }

  ///////////// 필터 칸
  final List<Image> filters = <Image>[
    Image.asset("assets/monk.jpg", fit: BoxFit.fill,),
    Image.asset("assets/splash.png", fit: BoxFit.fill,),
    Image.asset("assets/wave.jpg", fit: BoxFit.fill,),
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
            onTap: () => (
                //filterNum = index
                changeImage('assets/monkafter.jpg')
            )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    if(_image == null) getImage(ImageSource.gallery);

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
                  icon: Icon(Icons.image),
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                ),
                Spacer(),

                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
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

