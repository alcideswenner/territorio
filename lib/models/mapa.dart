class Mapa {
  int? _id;
  String? _urlMapa;
  String? _nome;
  int? _numeroTerritorio;
  bool? _status;
  String? _msgDataCarencia;
  int? _userAtual;
  int? _designacaoId;
  String? _urlGoogleMaps;

  Mapa(
      {required int id,
      required String urlMapa,
      required String nome,
      required int numeroTerritorio,
      required bool status,
      required String msgDataCarencia,
      required int userAtual,
      required int designacaoId,
      required String urlGoogleMaps}) {
    _id = id;
    _urlMapa = urlMapa;
    _nome = nome;
    _numeroTerritorio = numeroTerritorio;
    _status = status;
    _msgDataCarencia = msgDataCarencia;
    _userAtual = userAtual;
    _designacaoId = designacaoId;
    _urlGoogleMaps = urlGoogleMaps;
  }

  Mapa.id({required int? id}) {
    _id = id;
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

  String get msgDataCarencia => _msgDataCarencia!;
  set msgDataCarencia(String msgDataCarencia) =>
      _msgDataCarencia = msgDataCarencia;

  int get userAtual => _userAtual!;
  set userAtual(int userAtual) => _userAtual = userAtual;

  int get designacaoId => _designacaoId!;
  set designacaoId(int designacaoId) => _designacaoId = designacaoId;

  String get urlGoogleMaps => _urlGoogleMaps!;
  set urlGoogleMaps(String urlGoogleMaps) => _urlGoogleMaps = urlGoogleMaps;

  Mapa.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _urlMapa = json['urlMapa'];
    _nome = json['nome'];
    _msgDataCarencia = json['msgDataCarencia'];
    _numeroTerritorio = json['numeroTerritorio'];
    _status = json['status'];
    _userAtual = json['userAtual'];
    _designacaoId = json['designacaoId'];
    _urlGoogleMaps = json['urlGoogleMaps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['urlMapa'] = _urlMapa;
    data['nome'] = _nome;
    data['msgDataCarencia'] = _msgDataCarencia;
    data['numeroTerritorio'] = _numeroTerritorio;
    data['status'] = _status;
    data['userAtual'] = _userAtual;
    data['designacaoId'] = _designacaoId;
    data['urlGoogleMaps'] = _urlGoogleMaps;
    return data;
  }
}
