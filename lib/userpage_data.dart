// 받아와야할 것: 사용자 배경사진, 프로필사진, 이름, 게시물 수, 게시물 사진들

class UserPageData {
  final int id;
  final String username;
  final String email;
  final String dataJoined;
  final String background_picture;
  final String profile_picture;
  final int postSum;
  //final List<String> postUrls;

  UserPageData({    // 생성자
    required this.id,
    required this.username,
    required this.email,
    required this.dataJoined,
    required this.profile_picture,
    required this.background_picture,
    required this.postSum,
    //required this.postUrls
  });

  factory UserPageData.fromJson(Map<String, dynamic> json) {
    // print(json['username']);
    // print(json['profile_pic']);
    // print(json['total_posts']);
    return UserPageData(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      dataJoined: json['date_joined'],
      profile_picture: json['profile_pic'],
      background_picture: json['background_pic'],
      postSum: json['total_posts'],
      // postUrls: List<String>.from(json['postUrls'])
    );
  }
}

class UserPagePosts {
  List<String> postUrls=[];

  final int postid;
  final String title;
  final String desc;
  final String postUrl;
  final String postDate;
  final int id;

  UserPagePosts({    // 생성자
    required this.postid,
    required this.title,
    required this.desc,
    required this.postUrl,
    required this.postDate,
    required this.id,
  });

  factory UserPagePosts.fromJson(Map<String, dynamic> json) {
    return UserPagePosts(
      postid: json['post_id'],
      title: json['post_title'],
      desc: json['post_des'],
      postUrl: json['post_image'],
      postDate: json['post_date'],
      id: json['user_id'],
    );
  }
}