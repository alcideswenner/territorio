import 'package:territorio/models/mapa.dart';
import 'package:territorio/models/user.dart';

class Designacao {
  late final String dataDesignacao;
  late final User user;
  late final Mapa mapa;

  Designacao({
    required this.dataDesignacao,
    required this.user,
    required this.mapa,
  });

  Designacao.fromJson(Map<String, dynamic> json) {
    dataDesignacao = json['dataDesignacao'];
    user = User.fromJson(json['user']);
    mapa = Mapa.fromJson(json['mapa']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dataDesignacao'] = dataDesignacao;
    data['user'] = user.toJson();
    data['mapa'] = mapa.toJson();
    return data;
  }
}
