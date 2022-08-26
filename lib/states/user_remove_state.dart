abstract class UserRemoveState {}

class InitialUserRemoveState extends UserRemoveState {}

class SucessUserRemoveState extends UserRemoveState {}

class LoadingUserRemoveState extends UserRemoveState {}

class ErrorUserRemoveState extends UserRemoveState {
  final String message;

  ErrorUserRemoveState(this.message);
}
