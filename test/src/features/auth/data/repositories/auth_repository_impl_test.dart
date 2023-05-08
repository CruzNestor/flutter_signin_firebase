import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sign_in_firebase_auth/src/core/errors/exceptions.dart';
import 'package:sign_in_firebase_auth/src/core/errors/failures.dart';
import 'package:sign_in_firebase_auth/src/core/platform/network_info.dart';
import 'package:sign_in_firebase_auth/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sign_in_firebase_auth/src/features/auth/data/models/user_model.dart';
import 'package:sign_in_firebase_auth/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sign_in_firebase_auth/src/features/auth/domain/entities/user.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepositoryImpl tRepository;
  late MockNetworkInfo mockNetworkInfo;
  late MockAuthRemoteDataSource mockRemote;
  late String tPassword;
  late UserModel tUserModel;

  setUp((){
    mockNetworkInfo = MockNetworkInfo();
    mockRemote = MockAuthRemoteDataSource();
    tRepository = AuthRepositoryImpl(networkInfo: mockNetworkInfo, remote: mockRemote);
    tPassword = '123';
    tUserModel = UserModel.fromJSON(
      json.decode(fixture('user.json'))
    );
  });

  group('Device is online', () {    
    setUp((){
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('getUser should return a model when the call to the remote data source is successful', () async {
      when(() => mockRemote.getUser())
      .thenAnswer((_) async => tUserModel);

      final result = await tRepository.getUser();

      verify(() => mockRemote.getUser());
      expect(result, equals(Right(tUserModel)));
    });

    test('getUser should return a failure when the call to the remote data source is unsuccessful', () async {
      when(() => mockRemote.getUser())
      .thenThrow(CustomException(message: 'error'));

      final result = await tRepository.getUser();

      verify(() => mockRemote.getUser());
      expect(result, isA<Left<Failure, User>>());
    });

    test('signIn should return a model when the call to the remote data source is successful', () async {
      when(() => mockRemote.signIn(email: tUserModel.email, password: tPassword))
      .thenAnswer((_) async => tUserModel);

      final result = await tRepository.signIn(email: tUserModel.email, password: tPassword);

      verify(() => mockRemote.signIn(email: tUserModel.email, password: tPassword));
      expect(result, equals(Right(tUserModel)));
    });

    test('signIn should return a failure when the call to the remote data source is unsuccessful', () async {
      when(() => mockRemote.signIn(email: tUserModel.email, password: tPassword))
      .thenThrow(CustomException(message: 'error'));

      final result = await tRepository.signIn(email: tUserModel.email, password: tPassword);

      verify(() => mockRemote.signIn(email: tUserModel.email, password: tPassword));
      expect(result, isA<Left<Failure, User>>());
    });

    test('signInWithGoogle should return a model when the call to the remote data source is successful', () async {
      when(() => mockRemote.signInWithGoogle())
      .thenAnswer((_) async => tUserModel);

      final result = await tRepository.signInWithGoogle();

      verify(() => mockRemote.signInWithGoogle());
      expect(result, equals(Right(tUserModel)));
    });

    test('signInWithGoogle should return a failure when the call to the remote data source is unsuccessful', () async {
      when(() => mockRemote.signInWithGoogle())
      .thenThrow(CustomException(message: 'error'));

      final result = await tRepository.signInWithGoogle();

      verify(() => mockRemote.signInWithGoogle());
      expect(result, isA<Left<Failure, User>>());
    });

    test('signOut should return true when the call to the remote data source is successful', () async {
      when(() => mockRemote.signOut())
      .thenAnswer((_) async => true);

      final result = await tRepository.signOut();

      verify(() => mockRemote.signOut());
      expect(result, equals(const Right(true)));
    });

    test('signUp should return a model when the call to the remote data source is successful', () async {
      when(() => mockRemote.signUp(email: tUserModel.email, name: tUserModel.name, password: tPassword))
      .thenAnswer((_) async => tUserModel);

      final result = await tRepository.signUp(
        email: tUserModel.email, 
        name: tUserModel.name, 
        password: tPassword
      );

      verify(() => mockRemote.signUp(email: tUserModel.email, name: tUserModel.name, password: tPassword));
      expect(result, equals(Right(tUserModel)));
    });

    test('signUp should return a failure when the call to the remote data source is unsuccessful', () async {
      when(() => mockRemote.signUp(email: tUserModel.email, name: tUserModel.name, password: tPassword))
      .thenThrow(CustomException(message: 'error'));

      final result = await tRepository.signUp(email: tUserModel.email, name: tUserModel.name, password: tPassword);

      verify(() => mockRemote.signUp(email: tUserModel.email, name: tUserModel.name, password: tPassword));
      expect(result, isA<Left<Failure, User>>());
    });

  });
  
}