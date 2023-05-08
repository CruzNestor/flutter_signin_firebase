import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';

part 'auth_state.dart';


class AuthCubit extends Cubit<AuthState> {

  final GetUser getUserUseCase;
  final SignIn signInUseCase;
  final SignInWithGoogle signInWithGoogleUseCase;
  final SignOut signOutUseCase;
  final SignUp signUpUseCase;

  AuthCubit({
    required this.getUserUseCase,
    required this.signInUseCase,
    required this.signInWithGoogleUseCase,
    required this.signOutUseCase,
    required this.signUpUseCase
  }) : super(AuthInitial());

  Future<void> getUser() async {
    emit(Authenticating());
    final result = await getUserUseCase.call(NoUserParams());
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)), 
      (data) => emit(Authenticated(user: data))
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(Authenticating());
    final result = await signInUseCase(Credentials(email: email, password: password));
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (data) => emit(Authenticated(user: data))
    );
  }

  Future<void> signInWithGoogle() async {
    emit(AuthenticatingWithGoogle());
    final result = await signInWithGoogleUseCase(NoCredentials());
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (data) => emit(Authenticated(user: data))
    );
  }

  Future<void> signOut() async {
    emit(Loading());
    final result = await signOutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (data) => emit(Unauthenticated())
    );
  }

  Future<void> signUp({required String email, required String name, required String password}) async {
    emit(Authenticating());
    final result = await signUpUseCase(SignUpForm(
      email: email,
      name: name,
      password: password
    ));
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (data) => emit(Authenticated(user: data))
    );
  }
 
}
