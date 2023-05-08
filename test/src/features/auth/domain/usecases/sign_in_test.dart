import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sign_in_firebase_auth/src/features/auth/data/models/user_model.dart';

import 'package:sign_in_firebase_auth/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:sign_in_firebase_auth/src/features/auth/domain/usecases/sign_in.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignIn usecase;
  late UserModel tUserModel;

  setUp((){
    mockAuthRepository = MockAuthRepository();
    usecase = SignIn(repository: mockAuthRepository);
    tUserModel = UserModel.fromJSON(
      json.decode(fixture('user.json'))
    );
  });

  group('Sign in use case', () {
    String tPassword = '123';

    test('Should return a model', () async {
      when(() => mockAuthRepository.signIn(email: tUserModel.email, password: tPassword))
      .thenAnswer((_) async => Right(tUserModel));

      final result = await usecase(Credentials(email: tUserModel.email, password: tPassword));

      expect(result, Right(tUserModel));
      verify(() => mockAuthRepository.signIn(email: tUserModel.email, password: tPassword));
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });

} 