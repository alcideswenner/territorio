class Permissao {
  String? _nomePermissao;
  String? _descricao;

  Permissao({required String nomePermissao, required String descricao}) {
    _nomePermissao = nomePermissao;
    _descricao = descricao;
  }

  String get nomePermissao => _nomePermissao!;
  set nomePermissao(String nomePermissao) => _nomePermissao = nomePermissao;
  String get descricao => _descricao!;
  set descricao(String descricao) => _descricao = descricao;

  Permissao.fromJson(Map<String, dynamic> json) {
    _nomePermissao = json['nomePermissao'];
    _descricao = json['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['nomePermissao'] = _nomePermissao;
    data['descricao'] = _descricao;
    return data;
  }
}
