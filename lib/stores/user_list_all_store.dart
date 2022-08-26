import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:territorio/services/user_service.dart';
import 'dart:developer' as dev;
import 'package:territorio/states/user_list_all_state.dart';

class UserListAllStore extends ValueNotifier<UserListAllState> {
  final UserService userService;

  UserListAllStore(this.userService) : super(InitialUserListAllState());

  Future fetchListUsers(String token) async {
    value = LoadingUserListAllState();
    try {
      final listUser = await userService.fetchListUsers(token);
      value = SucessUserListAllState(listUser);
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        switch (e.response!.statusCode) {
          case 401:
            value = ErrorUserListAllState("Não autorizado!");
            break;
          case 403:
            value = ErrorUserListAllState("Sessão expirada ou não autorizado!");
            break;
          case 500:
            value = ErrorUserListAllState("Erro no sistema!");
            break;
          default:
            value =
                ErrorUserListAllState("Erro ao fazer login - Contate Wenner!");
        }
      } else {
        dev.log("AQUI $e");
        value = ErrorUserListAllState("Erro ao fazer login - Contate Wenner!");
      }
    }
  }

  void init() {
    value = InitialUserListAllState();
    notifyListeners();
  }
}
