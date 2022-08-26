import 'package:dio/dio.dart';
import 'package:territorio/models/mapa.dart';

class MapaServices {
  final Dio dio;

  MapaServices(this.dio);

  Future<List<Mapa>> fetchListMapas(String token, int? idUser) async {
    String url = "https://territorio-api.herokuapp.com/designacoes/find-mapas";
    if (idUser != null) {
      url = "$url?userAtual=$idUser";
    }

    final response = await dio.get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    final list = response.data as List;
    return list.map((e) => Mapa.fromJson(e)).toList();
  }

  Future<String> fetchDataCarenciaMapa(String token, int idMapa) async {
    final response = await dio.get(
        "https://territorio-api.herokuapp.com/designacoes/find-datacarencia-mapa/$idMapa",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    final dataCarencia = response.data as String;
    return dataCarencia;
  }
}
