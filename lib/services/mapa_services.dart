import 'package:dio/dio.dart';
import 'package:territorio/models/mapa.dart';

class MapaServices {
  final Dio dio;

  MapaServices(this.dio);

  Future<List<Mapa>> fetchListMapas(String token) async {
    final response = await dio.get(
        "https://territorio-api.herokuapp.com/designacoes/find-mapas",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    final list = response.data as List;
    return list.map((e) => Mapa.fromJson(e)).toList();
  }
}
