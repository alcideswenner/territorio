class AuthLoginResponse {
  String? _validUntil;
  String? _teste;
  String? _validFrom;
  String? _token;
  String? _username;
  List? _roles;

  AuthLoginResponse(
      {required String validUntil,
      required String teste,
      required String validFrom,
      required String token,
      required String username,
      required List roles}) {
    _validUntil = validUntil;
    _validFrom = validFrom;
    _token = token;
    _username = username;
    _roles = roles;
  }

  String get teste => _teste!;
  set teste(String teste) => _teste = teste;

  String get validUntil => _validUntil!;
  set validUntil(String validUntil) => _validUntil = validUntil;

  String get validFrom => _validFrom!;
  set validFrom(String validFrom) => _validFrom = validFrom;

  String get token => _token!;
  set token(String token) => _token = token;

  String get username => _username!;
  set username(String username) => _username = username;

  List get roles => _roles!;
  set roles(List roles) => _roles = roles;

  AuthLoginResponse.fromJson(Map<String, dynamic> json) {
    _validUntil = json['validUntil'];
    _teste = json['teste'];
    _validFrom = json['validFrom'];
    _token = json['token'];
    _username = json["username"];
    _roles = json["roles"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['validUntil'] = _validUntil;
    data['teste'] = _teste;
    data['validFrom'] = _validFrom;
    data['token'] = _token;
    data['username'] = _username;
    data['roles'] = _roles;
    return data;
  }
}
