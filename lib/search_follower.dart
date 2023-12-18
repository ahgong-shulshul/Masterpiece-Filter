import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:into_the_masterpiece/Home.dart';
import 'package:into_the_masterpiece/tempUserpage.dart';
import 'package:into_the_masterpiece/token_manager.dart';
import 'package:into_the_masterpiece/userpage.dart';
import 'enumdata.dart';

class SearchExe extends StatefulWidget{
  const SearchExe({Key? key}) :super(key: key);

  @override
  State<SearchExe> createState() => _SearchExeState();
}

class _SearchExeState extends State<SearchExe> {
  TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText="";

  _SearchExeState(){
    _filter.addListener(() {
      setState(() {
        _searchText=_filter.text;
      });
    });
  }

  List<String> tempUserList = [
    "min02choi", "sooking87", "ye.ann926", "leeyjin", "yejio_oi", "hyn.zzi", "um_im_ss",
    "shynewshy", "to.kk.ii", "desert_f0g", "didiwr", "zimini55", "victory_hee", "moonchloe12",
    "pea.a.a", "pretty077", "yenio_oi", "viviroiott", "kylie2192", "rlalstjd", "dldpwls01",
  ];

  List<String> tempImgPathList = [
    "assets/tmp1.png","assets/tmp2.png","assets/tmp3.png","assets/tmp4.png","assets/tmp5.png",
    "assets/tmp1.png","assets/tmp2.png","assets/tmp3.png","assets/tmp4.png","assets/tmp5.png",
    "assets/tmp1.png","assets/tmp2.png","assets/tmp3.png","assets/tmp4.png","assets/tmp5.png",
    "assets/tmp1.png","assets/tmp2.png","assets/tmp3.png","assets/tmp4.png","assets/tmp5.png",
    "assets/tmp1.png",
  ];

  // Future<List<UserPagePosts>> ReceiveUserPosts() async {
  //   final String apiUrl = 'http://10.0.2.2:8000/feed/';
  //   String? token = await TokenManager.loadToken();
  //
  //   if(token != null){
  //     final response = await http.get(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Token $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print('데이터 통신 성공');
  //       print(response.body);
  //
  //       // JSON 문자열을 파싱
  //       final List<dynamic> responseData = jsonDecode(response.body);
  //       print(responseData);
  //
  //       // 파싱된 데이터를 PostData 모델 객체의 리스트로 변환
  //       List<UserPagePosts> userPosts = responseData.map((json) => UserPagePosts.fromJson(json)).toList();
  //
  //       return userPosts;
  //     }
  //     else {
  //       print('데이터 얻기 실패');
  //       print('HTTP Status Code: ${response.statusCode}');
  //       throw Exception('Failed to fetch user data');
  //     }
  //   }
  //   else {
  //     print('토큰이 null입니다.');
  //     throw Exception('Token is null');
  //   }
  // }

  Widget _buildList(BuildContext context, List<String> list) {
    List<String> searchResults = [];

    for (String d in list) {
      if (d.contains(_searchText)) {
        searchResults.add(d);
      }
    }

    return Expanded(
      child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          padding: EdgeInsets.all(3),
          children: searchResults
              .map((data) => _buildListItem(context, data))
              .toList()),
    );
  }

  Widget _buildListItem(BuildContext context, String data) {
    return InkWell(
        child: Column(
            children: [
              ClipOval(
                child: Image.asset(
                  tempImgPathList[tempUserList.indexOf(data)],
                  width: 80.0, // 이미지의 크기를 조절할 수 있습니다.
                  height: 80.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8.0), // 텍스트와 이미지 사이에 간격 조절
              Text(data, // 실제 텍스트 내용을 추가해주세요
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.blue),
              )
            ],
        ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => TempUserPage()));
                }
    );
    //   TextButton(
    //   child: Text(data),
    //   onPressed: () {
    //     Navigator.push(
    //         context, MaterialPageRoute(builder: (_) => TempUserPage()));
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // 중앙 정렬
        elevation: 0.0,
        backgroundColor: Colors.white,

        title: Image.asset('assets/titleLogo.png'),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),  // 메뉴 버튼
            color: Colors.black,
            onPressed: () {
            // 메뉴 버튼 누르면 실행
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> UserPage())
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.home), // 홈 버튼
            color: Colors.black,
            onPressed: () {
               Navigator.push(
                   context,
                   MaterialPageRoute(builder: (_) => HomePage()));
            },
          ),
        ],

        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // Padding(
            //   padding: EdgeInsets.all(30),
            // ),

            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 6,
                      child: TextField(
                        focusNode: focusNode,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        autofocus: true,
                        controller: _filter,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white12,
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                          ),
                            suffixIcon: focusNode.hasFocus
                                ? IconButton(icon: Icon(Icons.cancel, size: 20,),
                                  onPressed: (){
                                    setState(() {
                                      _filter.clear();
                                      _searchText="";
                                    });
                                  },
                                  )
                                : Container(),
                          hintText: "검색",
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                  ),
                  focusNode.hasFocus
                    ? Expanded(child: TextButton(
                      child: Text("취소"),
                      onPressed:(){
                        setState(() {
                          _filter.clear();
                          _searchText="";
                          focusNode.unfocus();
                        });
                      }
                      ),
                     )
                    : Expanded(
                      flex: 0,
                      child: Container())
                ],
              ),
            ),
            _buildList(context, tempUserList),
          ],
        )
      )
      // Column(
      //   children: [
      //     TextField(
      //       controller: _searchController,
      //       decoration: InputDecoration(
      //         border: InputBorder.none,
      //         icon: Padding(
      //           padding: EdgeInsets.only(left: 30),
      //           child: Icon(Icons.search)
      //         )
      //       ),
      //       onChanged: (value) {
      //         // 검색어가 변경될 때 처리
      //         print('검색어: $value');
      //         // 여기서 검색 결과 업데이트 또는 필요한 동작 수행
      //       },
      //     ),
      //   ]
      // ),
    );
  }

}