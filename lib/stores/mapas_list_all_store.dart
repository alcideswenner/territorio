import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:territorio/services/mapa_services.dart';
import 'package:territorio/states/mapas_list_all_state.dart';
import 'dart:developer' as dev;

class MapasListAllStore extends ValueNotifier<MapasListAllState> {
  final MapaServices mapaServices;

  MapasListAllStore(this.mapaServices) : super(InitialMapasListAllState());

  Future fetchListMapas(String token, {int? idUser, String? bairro}) async {
    value = LoadingMapasListAllState();
    try {
      var listMapas = await mapaServices.fetchListMapas(token, idUser, bairro);
      value = SucessMapasListAllState(listMapas);
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        switch (e.response!.statusCode) {
          case 401:
            value = ErrorMapasListAllState("Não autorizado!");
            break;
          case 403:
            value =
                ErrorMapasListAllState("Sessão expirada ou não autorizado!");
            break;
          case 500:
            value = ErrorMapasListAllState("Erro no sistema!");
            break;
          default:
            value =
                ErrorMapasListAllState("Erro ao fazer login - Contate Wenner!");
        }
      } else {
        dev.log("AQUI $e");
        value = ErrorMapasListAllState("Erro ao fazer login - Contate Wenner!");
      }
    }
  }

  void init() {
    value = InitialMapasListAllState();
    notifyListeners();
  }
}
