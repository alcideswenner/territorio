// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cache_manager/cache_manager.dart';
import 'package:cache_manager/core/write_cache_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:territorio/models/auth_login_request.dart';

import 'package:territorio/services/auth_service.dart';
import 'package:territorio/states/auth_state.dart';

import '../models/auth_login_response.dart';

class AuthStore extends ValueNotifier<AuthState> {
  final AuthService auth;

  AuthStore(
    this.auth,
  ) : super(InitialAuthState());

  Future fetchAuthLogin(AuthLoginRequest request) async {
    value = LoadingAuthState();
    try {
      final loginUser = await auth.fetchLogin(request);

      JwtDecoder.decode(loginUser.token).forEach((key, value) {
        if (key.contains("roles")) {
          loginUser.roles = [value];
        }
      });

      loginUser.username = request.login;
      value = SucessAuthState(loginUser);
      salvaLoginCache(loginUser);
    } catch (e) {
      if (e is DioError) {
        switch (e.response!.statusCode) {
          case 401:
            value = ErrorAuthState("Não autorizado!");
            break;
          case 500:
            value = ErrorAuthState("Erro no sistema!");
            break;
          default:
            value = ErrorAuthState("Erro ao fazer login - Contate Wenner!");
        }
      }
    }
  }

  Future<void> salvaLoginCache(AuthLoginResponse loginUser) async {
    try {
      await WriteCache.setJson(key: "user", value: loginUser.toJson());
    } catch (e) {
      print("erro $e"); //Do something if error occurs
    }
  }

  Future<void> loginCache(AuthLoginResponse loginResponse) async {
    value = LoadingAuthState();
    await Future.delayed(const Duration(seconds: 1));
    try {
      value = SucessAuthState(loginResponse);
    } catch (e) {
      if (e is DioError) {
        switch (e.response!.statusCode) {
          case 401:
            value = ErrorAuthState("Não autorizado!");
            break;
          case 500:
            value = ErrorAuthState("Erro no sistema!");
            break;
          default:
            value = ErrorAuthState("Erro ao fazer login - Contate Wenner!");
        }
      }
    }
  }
}
