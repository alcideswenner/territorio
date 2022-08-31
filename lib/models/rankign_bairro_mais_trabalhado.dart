class RankingBairroMaisTrabalhado {
  String? _bairro;
  int? _qtd;

  RankingBairroMaisTrabalhado({
    required String bairro,
    required int qtd,
  }) {
    _bairro = bairro;
    _qtd = qtd;
  }

  RankingBairroMaisTrabalhado.fromJson(Map<String, dynamic> json) {
    _bairro = json['bairro'];
    _qtd = json['qtd'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['bairro'] = _bairro;
    data['qtd'] = _qtd;
    return data;
  }

  int get qtd => _qtd!;
  set qtd(int qtd) => _qtd = qtd;
  String get bairro => "${_bairro!}\n$qtd vezes";
  set bairro(String bairro) => _bairro = bairro;
}
