import 'package:dio/dio.dart';
import 'package:verxr/config/common/dio.dart';

class ProfileAPIController {
  Future<Response> callRegisterAPI(Map<String, dynamic> postData) async {
    final response = await dio.post('/register', data: postData);
    return response;
  }
}
