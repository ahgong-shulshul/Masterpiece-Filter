// 받아와야할 것: 사용자 배경사진, 프로필사진, 이름, 게시물 수, 게시물 사진들

import 'dart:html';

class UserPageData {
  String? username;
  String? background_picture;
  String? profile_picture;
  int postSum;
  final List<String> postUrls;

  UserPageData({    // 생성자
    required this.username,
    required this.background_picture,
    required this.profile_picture,
    required this.postSum,
    required this.postUrls
  });
/*
  Map<String, dynamic> toJson() => {
    'username': username,
    'back_ground': background_picture,
    'profile': profile_picture,
    'postSum': postSum,
    'postUrls': postUrls,
  };
*/
  factory UserPageData.fromJson(Map<String, dynamic> json) {
    return UserPageData(
      username: json['username'],
      profile_picture: json['profile'],
      background_picture: json['back_ground'],
      postSum: json['postSum'],
      postUrls: List<String>.from(json['postUrls'])
    );
  }
}