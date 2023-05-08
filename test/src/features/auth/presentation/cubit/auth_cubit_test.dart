import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sign_in_firebase_auth/src/features/auth/data/models/user_model.dart';
import 'package:sign_in_firebase_auth/src/features/auth/domain/usecases/get_user.dart';
import 'package:sign_in_firebase_auth/src/features/auth/domain/usecases/sign_in.dart';
import 'package:sign_in_firebase_auth/src/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:sign_in_firebase_auth/src/features/auth/domain/usecases/sign_out.dart';
import 'package:sign_in_firebase_auth/src/features/auth/domain/usecases/sign_up.dart';
import 'package:sign_in_firebase_auth/src/features/auth/presentation/cubit/auth_cubit.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockGetUser extends Mock implements GetUser {}
class MockSignIn extends Mock implements SignIn {}
class MockSignOut extends Mock implements SignOut {}
class MockSignUp extends Mock implements SignUp {}
class MockSingInWithGoogle extends Mock implements SignInWithGoogle {}

void main() {
  late MockGetUser mockGetUserUseCase;
  late MockSignIn mockSignInUseCase;
  late MockSingInWithGoogle mockSignInWithUseCase;
  late MockSignOut mockSignOutUseCase;
  late MockSignUp mockSignUpUseCase;
  late AuthCubit tAuthCubit;
  late String tPassword;
  late UserModel tUserModel;

  setUpAll((){
    mockGetUserUseCase = MockGetUser();
    mockSignInUseCase = MockSignIn();
    mockSignInWithUseCase = MockSingInWithGoogle();
    mockSignOutUseCase = MockSignOut();
    mockSignUpUseCase = MockSignUp();

    tAuthCubit = AuthCubit(
      getUserUseCase: mockGetUserUseCase,
      signInUseCase: mockSignInUseCase,
      signInWithGoogleUseCase: mockSignInWithUseCase,
      signOutUseCase: mockSignOutUseCase,
      signUpUseCase: mockSignUpUseCase
    );

    tPassword = '123';
    tUserModel = UserModel.fromJSON(
      json.decode(fixture('user.json'))
    );

    registerFallbackValue(Credentials(
      password: tPassword, 
      email: tUserModel.email
    ));

    registerFallbackValue(NoCredentials());

    registerFallbackValue(NoParams());

    registerFallbackValue(NoUserParams());
    
    registerFallbackValue(SignUpForm(
      email: tUserModel.email, 
      name: tUserModel.name,
      password: tPassword, 
    ));
    
  });

  group('AuthCubit', () {
    
    test('the initial state should be AuthInitial', () => {
      expect(tAuthCubit.state, equals(AuthInitial()))
    });

    blocTest<AuthCubit, AuthState>(
      'GetUser should emit Authenticating state and Authenticated state',
      build: () {
        when(() => mockGetUserUseCase(any<NoUserParams>()))
        .thenAnswer((_) async => Right(tUserModel));
        return tAuthCubit;
      },
      act: (cubit) => cubit.getUser(),
      expect: () => [isA<Authenticating>(), isA<Authenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'SignIn should emit authenticating state and authenticated state',
      build: () {
        when(() => mockSignInUseCase(any<Credentials>()))
        .thenAnswer((_) async => Right(tUserModel));
        return tAuthCubit;
      },
      act: (cubit) => cubit.signIn(email: tUserModel.email, password: tPassword),
      expect: () => [isA<Authenticating>(), isA<Authenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'Sign out should emit loading state and unauthenticated state',
      build: () {
        when(() => mockSignOutUseCase.call(any<NoParams>()))
        .thenAnswer((_) async => const Right(true));
        return tAuthCubit; 
      },
      act: (cubit) => cubit.signOut(),
      expect: () => [isA<Loading>(), isA<Unauthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'sign up event should emit authenticating state and authenticated state',
      build: () {
        when(() => mockSignUpUseCase(any<SignUpForm>()))
        .thenAnswer((_) async => Right(tUserModel));
        return tAuthCubit; 
      },
      act: (cubit) => cubit.signUp(
        email: tUserModel.email,
        name: tUserModel.name,
        password: tPassword
      ),
      expect: () => [isA<Authenticating>(), isA<Authenticated>()],
    );

  });
}