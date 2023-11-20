import 'package:demoapp/network/api_constant.dart';
import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static initDio() {
    dio = Dio(
      BaseOptions(
        baseUrl: Api_Constant.baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> postDataDio(
      {required String url, Map<String, dynamic>? data}) async {
    return await dio.post(
      url,
      data: data,
    );
  }
}
