import 'package:territorio/models/permissao.dart';

class User {
  int? _id;
  String? _username;
  String? _name;
  String? _password;
  List<Permissao>? _permissao;

  User(
      {required String username,
      required String name,
      required String password,
      required List<Permissao> permissao,
      int? id}) {
    _username = username;
    _name = name;
    _password = password;
    _permissao = permissao;
    _id = id;
  }

  User.id({required int? id}) {
    _id = id;
  }

  int get id => _id!;
  set id(int id) => _id = id;
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
    _id = json['id'];
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
    data['id'] = _id;
    if (_permissao != null) {
      data['permissao'] = _permissao!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
