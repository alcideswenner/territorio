import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:territorio/models/user.dart';
import 'package:territorio/services/user_service.dart';
import 'package:territorio/states/user_add_state.dart';
import 'dart:developer' as dev;

class UserAddStore extends ValueNotifier<UserAddState> {
  final UserService userService;

  UserAddStore(this.userService) : super(InitialUserAddState());

  Future fetchSaveUser(User request, String token) async {
    value = LoadingUserAddState();
    try {
      await userService.fetchSaveUser(request, token);
      value = SucessUserAddState();
      await userService.fetchListUsers(token);
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        switch (e.response!.statusCode) {
          case 401:
            value = ErrorUserAddState("Não autorizado!");
            break;
          case 500:
            value = ErrorUserAddState("Erro no sistema!");
            break;
          default:
            value = ErrorUserAddState("Erro ao fazer login - Contate Wenner!");
        }
      } else {
        dev.log("AQUI $e");
        value = ErrorUserAddState("Erro ao fazer login - Contate Wenner!");
      }
    }
  }

  void init() {
    value = InitialUserAddState();
    notifyListeners();
  }
}
