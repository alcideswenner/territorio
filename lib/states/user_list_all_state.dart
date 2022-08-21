import 'package:territorio/models/user.dart';

abstract class UserListAllState {}

class InitialUserListAllState extends UserListAllState {}

class SucessUserListAllState extends UserListAllState {
  final List<User> users;

  SucessUserListAllState(this.users);
}

class LoadingUserListAllState extends UserListAllState {}

class ErrorUserListAllState extends UserListAllState {
  final String message;

  ErrorUserListAllState(this.message);
}
