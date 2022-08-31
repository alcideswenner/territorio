import 'package:territorio/models/mapa.dart';
import 'package:territorio/models/rankign_bairro_mais_trabalhado.dart';

abstract class RankingBairroMaisTrabalhadoState {}

class InitialRankingBairroMaisTrabalhadoState
    extends RankingBairroMaisTrabalhadoState {}

class SucessRankingBairroMaisTrabalhadoState
    extends RankingBairroMaisTrabalhadoState {
  final List<RankingBairroMaisTrabalhado> ranking;

  SucessRankingBairroMaisTrabalhadoState(this.ranking);
}

class LoadingRankingBairroMaisTrabalhadoState
    extends RankingBairroMaisTrabalhadoState {}

class ErrorRankingBairroMaisTrabalhadoState
    extends RankingBairroMaisTrabalhadoState {
  final String message;

  ErrorRankingBairroMaisTrabalhadoState(this.message);
}
