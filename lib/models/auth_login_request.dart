class AuthLoginRequest {
  String? _login;
  String? _password;

  AuthLoginRequest({required String login, required String password}) {
    _login = login;
    _password = password;
  }

  String get login => _login!;
  set login(String login) => _login = login;
  String get password => _password!;
  set password(String password) => _password = password;

  AuthLoginRequest.fromJson(Map<String, dynamic> json) {
    _login = json['login'];
    _password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['login'] = _login;
    data['password'] = _password;
    return data;
  }
}
