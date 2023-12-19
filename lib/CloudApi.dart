import 'dart:convert';
import 'dart:typed_data';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gcloud/storage.dart';
import 'package:mime/mime.dart';

import 'enumdata.dart';

class CloudApi {
  late final auth.ServiceAccountCredentials _credentials;
  late auth.AutoRefreshingAuthClient _client;

  CloudApi(String json) {
    _credentials = auth.ServiceAccountCredentials.fromJson(json);
  }

  Future<ObjectInfo> save(
      String name, Uint8List imgBytes, String bucketName) async {
    _client = await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);

    var storage = Storage(_client, 'Into the masterpiece');
    var bucket = storage.bucket(bucketName);

    final type = lookupMimeType(name);
    return await bucket.writeBytes(name, imgBytes,
        metadata: ObjectMetadata(
          contentType: type,
        ));
  }
  /*
  {
  "user_id": "user-id-1",
  "style_type": "wave",
  "img_url": "https://storage.cloud.google.com/mf-content-images/user-id-1/hanriver.png"
  }*/

  Future<ObjectInfo> uploadJSON(
      String token, StyleType styleType, String url, String bucketName) async {
    _client = await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);

    String jsonContent = createJsonString(token, styleType, url);
    print(jsonContent);

    var storage = Storage(_client, 'Into the masterpiece');
    var bucket = storage.bucket(bucketName);

    // JSON 문자열을 Uint8List(바이트 배열)으로 변환
    Uint8List jsonData = Uint8List.fromList(utf8.encode(jsonContent));

    // 파일 업로드
    return await bucket.writeBytes(token, jsonData,
        metadata: ObjectMetadata(contentType: 'application/json'));
  }

  String createJsonString(String userId, StyleType styleType, String imgUrl) {
    Map<String, dynamic> jsonData = {
      'user_id': userId,
      'style_type': styleType.toString().split('.').last, // enum을 문자열로 변환
      'img_url': imgUrl,
    };

    return jsonEncode(jsonData);
  }
}
