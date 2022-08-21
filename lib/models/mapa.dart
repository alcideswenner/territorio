class Mapa {
  int? _id;
  String? _urlMapa;
  String? _nome;
  int? _numeroTerritorio;
  bool? _status;

  Mapa(
      {required int id,
      required String urlMapa,
      required String nome,
      required int numeroTerritorio,
      required bool status}) {
    _id = id;
    _urlMapa = urlMapa;
    _nome = nome;
    _numeroTerritorio = numeroTerritorio;
    _status = status;
  }

  int get id => _id!;
  set id(int id) => _id = id;
  String get urlMapa => _urlMapa!;
  set urlMapa(String urlMapa) => _urlMapa = urlMapa;
  String get nome => _nome!;
  set nome(String nome) => _nome = nome;
  int get numeroTerritorio => _numeroTerritorio!;
  set numeroTerritorio(int numeroTerritorio) =>
      _numeroTerritorio = numeroTerritorio;
  bool get status => _status!;
  set status(bool status) => _status = status;

  Mapa.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _urlMapa = json['urlMapa'];
    _nome = json['nome'];
    _numeroTerritorio = json['numeroTerritorio'];
    _status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['urlMapa'] = _urlMapa;
    data['nome'] = _nome;
    data['numeroTerritorio'] = _numeroTerritorio;
    data['status'] = _status;
    return data;
  }
}
