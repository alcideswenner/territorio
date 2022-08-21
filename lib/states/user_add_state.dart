abstract class UserAddState {}

class InitialUserAddState extends UserAddState {}

class SucessUserAddState extends UserAddState {}

class LoadingUserAddState extends UserAddState {}

class ErrorUserAddState extends UserAddState {
  final String message;

  ErrorUserAddState(this.message);
}
