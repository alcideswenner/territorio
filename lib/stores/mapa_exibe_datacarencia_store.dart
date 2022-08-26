import 'package:flutter/cupertino.dart';
import 'package:territorio/services/mapa_services.dart';

class ExibeDataCarenciaMapaStore extends ValueNotifier<String> {
  final MapaServices mapaServices;

  ExibeDataCarenciaMapaStore(this.mapaServices) : super("");

  Future<String> exibeDataCarencia(String token, int idMapa) async {
    try {
      value = await mapaServices.fetchDataCarenciaMapa(token, idMapa);
      return value;
    } catch (e) {
      value = "";
    }
    return value;
  }

  void init() {
    value = "";
    notifyListeners();
  }
}
