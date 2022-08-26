import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:territorio/services/designacao_service.dart';
import 'dart:developer' as dev;

import '../states/concluir_designacao_state.dart';

class ConcluirDesignacaoStore extends ValueNotifier<ConcluirDesignacaoState> {
  final DesignacaoServices designacaoService;

  ConcluirDesignacaoStore(this.designacaoService)
      : super(InitialConcluirDesignacaoState());

  Future fetchConcluirDesignacao(int id, String token) async {
    value = LoadingConcluirDesignacaoState();
    try {
      await designacaoService.fetchConcluirDesignacao(id, token);
      value = SucessConcluirDesignacaoState();
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        switch (e.response!.statusCode) {
          case 401:
            value = ErrorConcluirDesignacaoState("Não autorizado!");
            break;
          case 500:
            value = ErrorConcluirDesignacaoState("Erro no sistema!");
            break;
          case 403:
            value = ErrorConcluirDesignacaoState(
                "Sessão expirada ou não autorizado!");
            break;
          default:
            value = ErrorConcluirDesignacaoState(
                "Erro ao fazer login - Contate Wenner!");
        }
      } else {
        dev.log("AQUI $e");
        value = ErrorConcluirDesignacaoState(
            "Erro ao fazer login - Contate Wenner!");
      }
    }
  }

  void init() {
    value = InitialConcluirDesignacaoState();
    notifyListeners();
  }
}
