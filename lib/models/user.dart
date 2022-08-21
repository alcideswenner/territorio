import 'package:territorio/models/permissao.dart';

class User {
  String? _username;
  String? _name;
  String? _password;
  List<Permissao>? _permissao;

  User(
      {required String username,
      required String name,
      required String password,
      required List<Permissao> permissao}) {
    _username = username;
    _name = name;
    _password = password;
    _permissao = permissao;
  }

  String get username => _username!;
  set username(String username) => _username = username;
  String get name => _name!;
  set name(String name) => _name = name;
  String get password => _password!;
  set password(String password) => _password = password;
  List<Permissao> get permissao => _permissao!;
  set permissao(List<Permissao> permissao) => _permissao = permissao;

  User.fromJson(Map<String, dynamic> json) {
    _username = json['username'];
    _name = json['name'];
    _password = json['password'];
    if (json['permissao'] != null) {
      _permissao = [];
      json['permissao'].forEach((v) {
        _permissao!.add(Permissao.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['username'] = _username;
    data['name'] = _name;
    data['password'] = _password;
    if (_permissao != null) {
      data['permissao'] = _permissao!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
