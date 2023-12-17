import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 사진
          Positioned(
            top: 0,
            child: Image.network(
              'https://mblogthumb-phinf.pstatic.net/MjAxODAzMTFfMTUw/MDAxNTIwNzM1NzcxMjIx.VV7V_1Y-12Jz27VPfBx6o0Z6ghtfwswPa0hv2Pz0fcQg.l-n7q1BsV8uszXspCHo6DXoqDt5oKzdzMUgc11OBy2Ig.PNG.osy2201/1.png?type=w800',
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 4,
              fit: BoxFit.cover,
            ),
          ),

          // 검색버튼
          Positioned(
            top: 30.0,
            right: 50.0,
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {

              },
            ),
          ),
          
          // 배경 사진 설정 버튼
          Positioned(
            top: 30.0,
            right: 20.0,
            child: IconButton(
              icon: Icon(Icons.camera),
              onPressed: () {

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
              color: Colors.yellow, // 흰색 배경
            ),
          ),

          // 프로필 사진
          Positioned(
            bottom: MediaQuery.of(context).size.height / 4, // 배경 이미지 하단에서의 위치
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
                    child: Image.network(
                      'https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMTgy/MDAxNjA0MjI4ODc1NDMw.Ex906Mv9nnPEZGCh4SREknadZvzMO8LyDzGOHMKPdwAg.ZAmE6pU5lhEdeOUsPdxg8-gOuZrq_ipJ5VhqaViubI4g.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%95%98%EB%8A%98%EC%83%89.jpg?type=w800',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 유저 닉네임
                SizedBox(width: 20.0), // 이미지와 텍스트 간의 간격 조절
                Text(
                  'UserName',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.black,
                  ),
                ),

                // 포스팅 개수
                SizedBox(width: 20.0), // 이미지와 텍스트 간의 간격 조절
                Text(
                  'PostSum',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // 이미지들
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              height: 100.0, // 사진들의 높이
              child: ListView(
                scrollDirection: Axis.vertical, // 수평 방향으로 스크롤
                children: [
                  SizedBox(width: 20.0), // 좌측 여백
                  _buildPhoto('https://img1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/Pl7/image/xjgTErkwnIxLxEWStE_f9UEUHVs.jpg'),
                  _buildPhoto('https://img1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/Pl7/image/xjgTErkwnIxLxEWStE_f9UEUHVs.jpg'),
                  _buildPhoto('https://img1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/Pl7/image/xjgTErkwnIxLxEWStE_f9UEUHVs.jpg'),
                  _buildPhoto('https://img1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/Pl7/image/xjgTErkwnIxLxEWStE_f9UEUHVs.jpg'),
                  _buildPhoto('https://img1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/Pl7/image/xjgTErkwnIxLxEWStE_f9UEUHVs.jpg'),
                  _buildPhoto('https://img1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/Pl7/image/xjgTErkwnIxLxEWStE_f9UEUHVs.jpg'),
                  _buildPhoto('https://img1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/Pl7/image/xjgTErkwnIxLxEWStE_f9UEUHVs.jpg'),
                  _buildPhoto('https://img1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/Pl7/image/xjgTErkwnIxLxEWStE_f9UEUHVs.jpg'),
                  _buildPhoto('https://img1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/Pl7/image/xjgTErkwnIxLxEWStE_f9UEUHVs.jpg'),
                  _buildPhoto('https://img1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/Pl7/image/xjgTErkwnIxLxEWStE_f9UEUHVs.jpg'),
                  _buildPhoto('https://img1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/Pl7/image/xjgTErkwnIxLxEWStE_f9UEUHVs.jpg'),
                  // 추가적인 사진들을 필요에 따라 나열
                  SizedBox(width: 20.0), // 우측 여백
                ],
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
      margin: EdgeInsets.all(5.0), // 사진들 사이의 간격 조절
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // 검은색 테두리
          width: 2.0, // 테두리 두께
        ),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}