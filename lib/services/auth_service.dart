import 'package:dio/dio.dart';
import 'package:territorio/models/auth_login_request.dart';
import 'package:territorio/models/auth_login_response.dart';

class AuthService {
  final Dio dio;

  AuthService(this.dio);

  Future<AuthLoginResponse> fetchLogin(AuthLoginRequest request) async {
    final response = await dio.post(
        "https://territorio-api.herokuapp.com/login",
        data: request.toJson());
    final authLoginResponse = response.data as Map<String, dynamic>;
    return AuthLoginResponse.fromJson(authLoginResponse);
  }
}
