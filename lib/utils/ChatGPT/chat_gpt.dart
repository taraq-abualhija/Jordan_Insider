import 'package:dio/dio.dart';

class ChatGPT {
  static Dio dio = Dio();
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://api.openai.com/v1/completions",
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer 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'
        },
      ),
    );
  }

  static Future<Response> ask(String msg) async {
    return dio.post('', data: {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': msg}
      ],
    });
  }
}
