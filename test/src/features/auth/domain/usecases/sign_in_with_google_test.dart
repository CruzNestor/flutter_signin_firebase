import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sign_in_firebase_auth/src/features/auth/data/models/user_model.dart';

import 'package:sign_in_firebase_auth/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:sign_in_firebase_auth/src/features/auth/domain/usecases/sign_in_with_google.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignInWithGoogle usecase;
  late UserModel tUserModel;

  setUp((){
    mockAuthRepository = MockAuthRepository();
    usecase = SignInWithGoogle(repository: mockAuthRepository);
    tUserModel = UserModel.fromJSON(
      json.decode(fixture('user.json'))
    );
  });

  group('Sign in with google use case', () {
    test('Should return a model', () async {
      when(() => mockAuthRepository.signInWithGoogle())
      .thenAnswer((_) async => Right(tUserModel));

      final result = await usecase(NoCredentials());

      expect(result, Right(tUserModel));
      verify(() => mockAuthRepository.signInWithGoogle());
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });

} 