import 'package:dio/dio.dart';

import '../models/designacao.dart';

class DesignacaoServices {
  final Dio dio;

  DesignacaoServices(this.dio);

  Future<void> fetchSalvaDesignacao(Designacao request, String token) async {
    await dio.post("https://territorio-api.herokuapp.com/designacoes",
        options: Options(headers: {"Authorization": "Bearer $token"}),
        data: request.toJson());
  }

  Future<void> fetchConcluirDesignacao(int idDesignacao, String token) async {
    await dio.put(
        "https://territorio-api.herokuapp.com/designacoes/$idDesignacao",
        options: Options(headers: {"Authorization": "Bearer $token"}));
  }
}
