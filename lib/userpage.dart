import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:into_the_masterpiece/Home.dart';
import 'package:into_the_masterpiece/camera.dart';
import 'package:into_the_masterpiece/enumdata.dart';
import 'package:into_the_masterpiece/search_follower.dart';


class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // 받아와야할 것: 사용자 배경사진, 프로필사진, 이름, 게시물 수, 게시물 사진들

  File? _BGImage;
  File? _ProfileImage;
  final picker = ImagePicker();

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getBGImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _BGImage = File(image!.path); // 가져온 이미지를 _image에 저장
    });
  }
  Future getProfileImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _ProfileImage = File(image!.path); // 가져온 이미지를 _image에 저장
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 사진
          Positioned(
            top: 0,
            child: _BGImage == null
              ?Image.network(
              'https://blog.kakaocdn.net/dn/bnbTHu/btr5PSP5iSM/iktsvSfeUxKXZ2le4XlKL1/img.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              fit: BoxFit.cover,
              )
             :Image.file(
                File(_BGImage!.path),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
                fit: BoxFit.cover,
              )
          ),

          // 검색버튼
          Positioned(
            top: 30.0,
            right: 50.0,
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchExe())
                );
              },
            ),
          ),

          // 사진 찍기 버튼
          Positioned(
            top: 30.0,
            right: 90.0,
            child: IconButton(
              icon: Icon(Icons.camera),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraExe()),
                );
              },
            ),
          ),

          // 배경 사진 설정 버튼
          Positioned(
            top: 30.0,
            right: 20.0,
            child: PopupMenuButton<SettingMenu>(
              onSelected: (SettingMenu res){
                if(res == SettingMenu.changeBGImg){
                  getBGImage(ImageSource.gallery);
                }
                else if(res == SettingMenu.changProfileImg){
                  getProfileImage(ImageSource.gallery);
                }
                else{
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => HomePage()));
                }
              },
              itemBuilder: (BuildContext context){
                return [
                  PopupMenuItem(
                    value: SettingMenu.changeBGImg,
                    child: Text("배경 변경"),
                  ),
                  PopupMenuItem(
                    value: SettingMenu.changProfileImg,
                    child: Text("프로필 변경"),
                  ),
                  PopupMenuItem(
                    value: SettingMenu.goHome,
                    child: Text("홈으로"),
                  ),
                ];
              },
            ),
          ),

          // 흰색 박스
          Positioned(
            top: MediaQuery.of(context).size.height / 4, // 배경 이미지 아래에 위치
            left: 0, // 좌측에 위치
            right: 0, // 우측에 위치
            child: Container(
              height: 60.0, // 박스의 세로 길이
              color: Colors.white70, // 흰색 배경
            ),
          ),

          // 프로필 사진
          Positioned(
            top: MediaQuery.of(context).size.height / 4 - 50, // 배경 이미지 하단에서의 위치
            left: 30.0, // 배경 이미지 좌측에서의 위치
            child: Row(
              children: [
              // 프로필 이미지
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                  color: Colors.black, // 검은색 테두리
                  width: 3.0, // 테두리 두께
                  ),
                ),

              child: ClipOval(
              child: _ProfileImage == null
                ?Image.network(
                'https://tumblbug-pci.imgix.net/873c897e881d022a0232b64dd3185ef30900d695/7cfb3abbd6858246bf2035597db71d580c2d498a/c65bafbe8e9498d7c5e0d1df698eb3bd734170da/2bfdcf8a-9171-4ff8-8c42-0cb0fd0f9faf.jpeg?ixlib=rb-1.1.0&w=1240&h=930&auto=format%2Ccompress&lossless=true&fit=crop&s=e880d7909a5ff6649147526c7eae0ecc',
                fit: BoxFit.cover,
                )
                  :Image.file(
                File(_ProfileImage!.path),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
                fit: BoxFit.cover,
              )
              ),
              ),
              ],
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height / 4 + 20, // 배경 이미지 하단에서의 위치
            right: 20.0, // 배경 이미지 좌측에서의 위치
            child: Row(
              children: [
                // 유저 닉네임
                SizedBox(width: 20.0), // 이미지와 텍스트 간의 간격 조절
                Text(
                  '1004jumto',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),

                // 포스팅 개수
                SizedBox(width: 20.0), // 이미지와 텍스트 간의 간격 조절
                Text(
                  '20posts',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // 이미지들
          Positioned(
            top: MediaQuery.of(context).size.height / 4 + 60,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * (3 / 4) - 60,

              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 열의 수
                  crossAxisSpacing: 8.0, // 열 간격
                  mainAxisSpacing: 8.0, // 행 간격
                ),
                  itemCount: 20, // 그리드 아이템의 총 개수
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _showImageDialog(
                            'https://img1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/Pl7/image/xjgTErkwnIxLxEWStE_f9UEUHVs.jpg');
                      },
                      child: _buildPhoto(
                          'https://img1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/Pl7/image/xjgTErkwnIxLxEWStE_f9UEUHVs.jpg'),
                    );
                  }
              ),
            )
          ),
        ],
      ),
    );
  }

  // 정사각형 모양의 사진 위젯을 생성하는 함수
  Widget _buildPhoto(String imageUrl) {
    return Container(
      margin: EdgeInsets.all(1.0), // 사진들 사이의 간격 조절
      width: 40.0,
      height: 40.0,

      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  // 클릭한 사진을 크게 보여주는 다이얼로그
  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: InteractiveViewer(
            boundaryMargin: EdgeInsets.all(20.0),
            minScale:0.5,
            maxScale:2.0,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
