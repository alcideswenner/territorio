import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:territorio/services/user_service.dart';
import 'dart:developer' as dev;

import 'package:territorio/states/user_remove_state.dart';

class UserRemoveStore extends ValueNotifier<UserRemoveState> {
  final UserService userService;

  UserRemoveStore(this.userService) : super(InitialUserRemoveState());

  Future fetchRemoveUser(int id, String token) async {
    value = LoadingUserRemoveState();
    try {
      final res = await userService.fetchRemoveUser(id, token);
      if (res == 1) {
        value = SucessUserRemoveState();
      } else {
        value = ErrorUserRemoveState("Erro ao remover usuario");
      }
    } catch (e) {
      if (e is DioError) {
        switch (e.response!.statusCode) {
          case 401:
            value = ErrorUserRemoveState("Não autorizado!");
            break;
          case 403:
            value = ErrorUserRemoveState("Sessão expirada ou não autorizado!");
            break;
          case 500:
            value = ErrorUserRemoveState("Erro no sistema!");
            break;
          default:
            value =
                ErrorUserRemoveState("Erro ao fazer login - Contate Wenner!");
        }
      } else {
        dev.log("AQUI $e");
        value = ErrorUserRemoveState("Erro ao fazer login - Contate Wenner!");
      }
    }
  }

  void init() {
    value = InitialUserRemoveState();
    notifyListeners();
  }
}
