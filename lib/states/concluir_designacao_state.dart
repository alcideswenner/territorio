abstract class ConcluirDesignacaoState {}

class InitialConcluirDesignacaoState extends ConcluirDesignacaoState {}

class SucessConcluirDesignacaoState extends ConcluirDesignacaoState {}

class LoadingConcluirDesignacaoState extends ConcluirDesignacaoState {}

class ErrorConcluirDesignacaoState extends ConcluirDesignacaoState {
  final String message;

  ErrorConcluirDesignacaoState(this.message);
}
