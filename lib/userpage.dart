import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:into_the_masterpiece/Home.dart';
import 'package:into_the_masterpiece/camera.dart';
import 'package:into_the_masterpiece/enumdata.dart';
import 'package:into_the_masterpiece/search_follower.dart';
import 'package:into_the_masterpiece/token_manager.dart';
import 'package:into_the_masterpiece/userpage_data.dart';


class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserPageData? userData;
  UserPagePosts? userPosts;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      userData = await ReceiveUserData();
      userPosts = await ReceiveUserPosts();
      setState(() {}); // 상태를 갱신하여 위젯을 다시 그림
    } catch (e) {
      print('Error loading user data: $e');
    }
  }
  // 받아와야할 것: 사용자 배경사진, 프로필사진, 이름, 게시물 수, 게시물 사진들
  Future<UserPageData> ReceiveUserData() async {
    final String apiUrl = 'http://10.0.2.2:8000/customuser/mypage/';
    String? token = await TokenManager.loadToken();

    if(token != null){
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        print('데이터 통신 성공');
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        return UserPageData.fromJson(responseData);
      }
      else {
        print('데이터 얻기 실패');
        print('HTTP Status Code: ${response.statusCode}');
        throw Exception('Failed to fetch user data');
      }
    }
    else {
      print('토큰이 null입니다.');
      throw Exception('Token is null');
    }
  }

  Future<UserPagePosts> ReceiveUserPosts() async {
    final String apiUrl = 'http://10.0.2.2:8000/customuser/mypage/';
    String? token = await TokenManager.loadToken();

    if(token != null){
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        print('데이터 통신 성공');
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        return UserPagePosts.fromJson(responseData);
      }
      else {
        print('데이터 얻기 실패');
        print('HTTP Status Code: ${response.statusCode}');
        throw Exception('Failed to fetch user data');
      }
    }
    else {
      print('토큰이 null입니다.');
      throw Exception('Token is null');
    }
  }

  Future<void> SendChangedUserData() async {
    final String apiUrl = 'http://10.0.2.2:8000/customuser/social-login/';
    String? token = await TokenManager.loadToken();

    if(token != null){
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body:jsonEncode({
          'back_ground': _BGImage?.path,
          'profile': _ProfileImage?.path,
        })
      );

      if (response.statusCode == 200) {
        print('데이터 전송 성공');
      }
      else {
        print('데이터 전송 실패');
        print('HTTP Status Code: ${response.statusCode}');
        throw Exception('Failed to fetch user data');
      }
    }
    else {
      print('토큰이 null입니다.');
      throw Exception('Token is null');
    }
  }

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
              'https://photo.coolenjoy.co.kr/data/editor/1812/20181204171053_e6c3ceb981729bb7540012c70b72d769_t2n3.jpg',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              fit: BoxFit.cover,
              )
             :Image.file(
              File(userData!.background_picture!),
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

          // 설정 버튼
          Positioned(
            top: 30.0,
            right: 20.0,
            child: PopupMenuButton<SettingMenu>(
              onSelected: (SettingMenu res){
                if(res == SettingMenu.changeBGImg){   // 배경 사진 변경
                  getBGImage(ImageSource.gallery);
                  SendChangedUserData();
                }
                else if(res == SettingMenu.changProfileImg){    // 프로필 사진 변경
                  getProfileImage(ImageSource.gallery);
                  SendChangedUserData();
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
                    'https://i.pinimg.com/236x/39/a1/eb/39a1eb1485516800d84981a72840d60e.jpg',
                    fit: BoxFit.cover,
                    )
                    :Image.file(
                      File(userData!.profile_picture!),
                      fit: BoxFit.cover,
                    )
                    )
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
                  userData!.username!,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),

                // 포스팅 개수
                SizedBox(width: 20.0), // 이미지와 텍스트 간의 간격 조절
                Text(
                  userData!.postSum!.toString(),
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
                  crossAxisSpacing: 5.0, // 열 간격
                  mainAxisSpacing: 5.0, // 행 간격
                ),
                  itemCount: userData!.postSum, // 그리드 아이템의 총 개수
                  itemBuilder: (context, index) {
                    String imageUrl = userPosts!.postUrls[index];
                    return GestureDetector(
                      onTap: () {
                        _showImageDialog(imageUrl);
                    },

                      child: _buildPhoto(imageUrl)
                    );
                }
              ),
            )
          ),
        ],
      )
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
