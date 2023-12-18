class ShortProfile {
  final int id;
  final String username;
  final String email;
  final String profile_picture;

  ShortProfile({    // 생성자
    required this.id,
    required this.username,
    required this.email,
    required this.profile_picture,
  });

  factory ShortProfile.fromJson(Map<String, dynamic> json) {
    return ShortProfile(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profile_picture: json['profile_pic'],
    );
  }
}