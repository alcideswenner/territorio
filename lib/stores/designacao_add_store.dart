import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:territorio/models/designacao.dart';
import 'package:territorio/services/designacao_service.dart';
import 'dart:developer' as dev;
import '../states/designacao_add_state.dart';

class DesignacaoAddStore extends ValueNotifier<DesignacaoAddState> {
  final DesignacaoServices designacaoServices;

  DesignacaoAddStore(this.designacaoServices)
      : super(InitialDesignacaoAddState());

  Future fetchSalvaDesignacao(Designacao request, String token) async {
    value = LoadingDesignacaoAddState();
    try {
      await designacaoServices.fetchSalvaDesignacao(request, token);
      value = SucessDesignacaoAddState();
    } catch (e) {
      if (e is DioError) {
        switch (e.response!.statusCode) {
          case 400:
            if (e.response!.data.toString().contains("Mapa não disponível")) {
              value = ErrorDesignacaoAddState(e.response!.data.toString());
            } else {}
            break;
          case 401:
            value = ErrorDesignacaoAddState("Não autorizado!");
            break;
          case 403:
            value =
                ErrorDesignacaoAddState("Sessão expirada ou não autorizado!");
            break;
          case 500:
            value = ErrorDesignacaoAddState("Erro no sistema!");
            break;
          default:
            value = ErrorDesignacaoAddState(
                "Erro ao fazer login - Contate Wenner!");
        }
      } else {
        dev.log("AQUI $e");
        value =
            ErrorDesignacaoAddState("Erro ao fazer login - Contate Wenner!");
      }
    }
  }

  void init() {
    value = InitialDesignacaoAddState();
    notifyListeners();
  }
}
