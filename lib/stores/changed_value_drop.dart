import 'package:flutter/cupertino.dart';

String? mapaEscolhido;

class ChangedValueDrop extends ValueNotifier<String> {
  ChangedValueDrop() : super(mapaEscolhido ?? "Todos os Mapas");
  var items = [
    'Todos os Mapas',
    'Anil',
    'Bela Vista',
    'Centro',
    'Multirão',
    'Novo Tempo',
    "Olho D'Aguinha",
    'Quiabos',
    'São Francisco',
    'Sarney',
    'Subestação'
  ];

  Future<void> setValue(String? bairro) async {
    value = bairro!;
    mapaEscolhido = value;
    notifyListeners();
  }

  void init() {
    value = "Todos os Mapas";
    mapaEscolhido = value;
    notifyListeners();
  }
}
