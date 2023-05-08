part of 'auth_cubit.dart';


abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class Authenticating extends AuthState {}

class AuthenticatingWithGoogle extends AuthState {}

class AuthFailure extends AuthState {
  const AuthFailure({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

class Authenticated extends AuthState {
  const Authenticated({required this.user});
  final User user;

  @override
  List<Object> get props => [user];
}

class Loading extends AuthState {}

class Unauthenticated extends AuthState {}