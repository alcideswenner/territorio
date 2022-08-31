import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:territorio/services/mapa_services.dart';
import 'dart:developer' as dev;
import '../states/ranking_bairro_mais_trabalhado_state.dart';

class RankingBairroMaisTrabalhadoStore
    extends ValueNotifier<RankingBairroMaisTrabalhadoState> {
  final MapaServices mapaServices;

  RankingBairroMaisTrabalhadoStore(this.mapaServices)
      : super(InitialRankingBairroMaisTrabalhadoState());

  Future fetchRanking(String token) async {
    value = LoadingRankingBairroMaisTrabalhadoState();
    try {
      var listaRanking =
          await mapaServices.fetchRankingBairroMaisTrabalhado(token);
      value = SucessRankingBairroMaisTrabalhadoState(listaRanking);
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        switch (e.response!.statusCode) {
          case 401:
            value = ErrorRankingBairroMaisTrabalhadoState("Não autorizado!");
            break;
          case 403:
            value = ErrorRankingBairroMaisTrabalhadoState(
                "Sessão expirada ou não autorizado!");
            break;
          case 500:
            value = ErrorRankingBairroMaisTrabalhadoState("Erro no sistema!");
            break;
          default:
            value = ErrorRankingBairroMaisTrabalhadoState(
                "Erro ao fazer login - Contate Wenner!");
        }
      } else {
        dev.log("AQUI $e");
        value = ErrorRankingBairroMaisTrabalhadoState(
            "Erro ao fazer login - Contate Wenner!");
      }
    }
  }

  void init() {
    value = InitialRankingBairroMaisTrabalhadoState();
    notifyListeners();
  }
}
