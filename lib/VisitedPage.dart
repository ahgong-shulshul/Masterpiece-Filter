import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:into_the_masterpiece/search_follower.dart';
import 'package:into_the_masterpiece/token_manager.dart';
import 'package:into_the_masterpiece/userpage_data.dart';

class VisitedPage extends StatefulWidget{
  final int id;

  const VisitedPage({Key? key, required this.id}) : super(key: key);

  @override
  State<VisitedPage> createState() => _VisitedPageState();

}

class _VisitedPageState extends State<VisitedPage> {
  UserPageData? userData;
  List<UserPagePosts>? userPosts;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      userData = await ReceiveUserData();
      userPosts = await ReceiveUserPosts();
      print("방문: $userData");
      setState(() {}); // 상태를 갱신하여 위젯을 다시 그림
    } catch (e) {
      print('Error loading user data: $e');
    }
  }
  // 받아와야할 것: 사용자 배경사진, 프로필사진, 이름, 게시물 수, 게시물 사진들
  Future<UserPageData> ReceiveUserData() async {
    int idInApi = widget.id;
    final String apiUrl = 'http://10.0.2.2:8000/customuser/$idInApi/detail';

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
        print(response.body);

        // JSON 문자열을 파싱
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);

        if(responseData.isNotEmpty){
          //final Map<String, dynamic> userDataMap = responseData.first;
          //print(userDataMap);
          return UserPageData.fromJson(responseData);
        }
        else{
          throw Exception('Empty response data');
        }

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

  Future<List<UserPagePosts>> ReceiveUserPosts() async {
    int idInApi = widget.id;

    final String apiUrl = 'http://10.0.2.2:8000/feed/$idInApi/post';
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
        print('데이터 통신 성공!');
        print(response.body);

        // JSON 문자열을 파싱
        final List<dynamic> responseData = jsonDecode(response.body);
        print(responseData);

        // 파싱된 데이터를 PostData 모델 객체의 리스트로 변환
        List<UserPagePosts> userPosts = responseData.map((json) => UserPagePosts.fromJson(json)).toList();

        return userPosts;
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 사진
          Positioned(
              top: 0,
              child: userData == null
                  ?Image.network(
                'https://photo.coolenjoy.co.kr/data/editor/1812/20181204171053_e6c3ceb981729bb7540012c70b72d769_t2n3.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
                fit: BoxFit.cover,
              )
                  :Image.network(
                userData!.background_picture!,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
                fit: BoxFit.cover,
              )
          ),

          // 검색버튼
          Positioned(
            top: 30.0,
            right: 20.0,
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
                      child: userData == null
                          ?Image.network(
                        'https://i.pinimg.com/236x/39/a1/eb/39a1eb1485516800d84981a72840d60e.jpg',
                        fit: BoxFit.cover,
                      )
                          :Image.network(
                        userData!.profile_picture!,
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
            left: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  userData != null
                      ? userData!.username! : "unkown",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                  ),
                ),

                // 포스팅 개수
                SizedBox(width: 20.0), // 이미지와 텍스트 간의 간격 조절
                Text(
                  userData != null ? userData!.postSum!.toString() + " posts" : "Nan",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.blueAccent,
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
                    itemCount: userData != null ? userData!.postSum : 0, // 그리드 아이템의 총 개수
                    itemBuilder: (context, index) {
                      if (userPosts != null) {
                        String imageUrl = userPosts![index].postUrl;
                        return GestureDetector(
                            onTap: () {
                              _showImageDialog(imageUrl, userPosts![index]);
                            },

                            child: _buildPhoto(imageUrl)
                        );
                      }
                      else{

                      }
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

  void _showImageDialog(String imageUrl, UserPagePosts data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          /// 배경 컬러
          backgroundColor: Colors.grey.shade100,
          /// 그림자 컬러
          shadowColor: Colors.black,

          /// 다이얼로그의 모양 설정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          /// z축 높이, elevation의 값이 높을 수록 그림자가 아래 위치하게 됩니다.
          elevation: 10,

          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.title,
                style: TextStyle(fontSize: 20),
              ),

              Text(
                data.postDate.split("T").first,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
          content: Stack(
            children: [
              Positioned(
                child: InteractiveViewer(
                  boundaryMargin: EdgeInsets.all(1.0),
                  minScale:0.5,
                  maxScale:2.0,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height / 8,
                  padding: EdgeInsets.only(bottom: 15.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0), // 맨 위는 투명
                        Colors.black.withOpacity(0.5), // 중간은 반 투명
                        Colors.black.withOpacity(0.8), // 맨 아래는 좀 진한 투명
                      ],
                    ), // 투명한 검은색 배경
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      data.desc,
                      style: TextStyle(
                        color: Colors.white, // 흰색 텍스트
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

        );
      },
    );
  }
}
