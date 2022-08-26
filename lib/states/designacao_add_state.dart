abstract class DesignacaoAddState {}

class InitialDesignacaoAddState extends DesignacaoAddState {}

class SucessDesignacaoAddState extends DesignacaoAddState {}

class LoadingDesignacaoAddState extends DesignacaoAddState {}

class ErrorDesignacaoAddState extends DesignacaoAddState {
  final String message;

  ErrorDesignacaoAddState(this.message);
}
