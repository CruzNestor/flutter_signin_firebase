import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sign_in_firebase_auth/src/features/auth/data/models/user_model.dart';

import 'package:sign_in_firebase_auth/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:sign_in_firebase_auth/src/features/auth/domain/usecases/sign_up.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignUp usecase;
  late UserModel tUserModel;

  setUp((){
    mockAuthRepository = MockAuthRepository();
    usecase = SignUp(repository: mockAuthRepository);
    tUserModel = UserModel.fromJSON(
      json.decode(fixture('user.json'))
    );
  });

  group('Sign up use case', () {
    String tPassword = '123';

    test('Should return a model', () async {
      when(() => mockAuthRepository.signUp(email: tUserModel.email, name: tUserModel.name, password: tPassword))
      .thenAnswer((_) async => Right(tUserModel));

      final result = await usecase(SignUpForm(email: tUserModel.email, name: tUserModel.name, password: tPassword));

      expect(result, Right(tUserModel));
      verify(() => mockAuthRepository.signUp(email: tUserModel.email, name: tUserModel.name, password: tPassword));
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });

} 