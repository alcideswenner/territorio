import 'package:territorio/models/auth_login_response.dart';

abstract class AuthState {}

class InitialAuthState extends AuthState {}

class SucessAuthState extends AuthState {
  final AuthLoginResponse authLoginResponse;

  SucessAuthState(this.authLoginResponse);
}

class LoadingAuthState extends AuthState {}

class ErrorAuthState extends AuthState {
  final String message;

  ErrorAuthState(this.message);
}
