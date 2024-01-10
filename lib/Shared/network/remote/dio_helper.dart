import 'dart:typed_data';

import 'package:dio/dio.dart';

class DioHelper {
  static Dio dio = Dio();

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: "http://20.203.96.69/api/",
        receiveDataWhenStatusError: true,
        headers: {
          'Accept': 'text/plain',
        },
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    required Map<String, dynamic> query,
  }) async {
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
  }) async {
    return dio.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> uploadImageToServer(List<Uint8List?> images) async {
    String endPointUrl = 'TouristSite/uploadImage';

    List<MultipartFile> imageFiles = [];
    for (int i = 0; i < images.length; i++) {
      Uint8List imageBytes = images[i]!;

      imageFiles.add(
        MultipartFile.fromBytes(
          imageBytes,
          filename: 'image_$i.jpg',
        ),
      );
    }

    FormData formData = FormData.fromMap({
      'images': imageFiles,
    });

    return dio.post(
      endPointUrl,
      data: formData,
    );
  }

  static Future<Response> updateData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
  }) async {
    return dio.put(
      url,
      data: data,
    );
  }

  static Future<Response> deleteData({
    required String url,
  }) async {
    return dio.delete(url);
  }
}
