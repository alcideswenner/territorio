import 'package:territorio/models/mapa.dart';
import 'package:territorio/models/user.dart';

abstract class MapasListAllState {}

class InitialMapasListAllState extends MapasListAllState {}

class SucessMapasListAllState extends MapasListAllState {
  final List<Mapa> mapas;

  SucessMapasListAllState(this.mapas);
}

class LoadingMapasListAllState extends MapasListAllState {}

class ErrorMapasListAllState extends MapasListAllState {
  final String message;

  ErrorMapasListAllState(this.message);
}
