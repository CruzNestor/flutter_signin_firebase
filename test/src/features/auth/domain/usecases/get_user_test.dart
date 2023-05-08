import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sign_in_firebase_auth/src/features/auth/data/models/user_model.dart';
import 'package:sign_in_firebase_auth/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:sign_in_firebase_auth/src/features/auth/domain/usecases/get_user.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late GetUser usecase;
  late UserModel tUserModel;

  setUp((){
    mockAuthRepository = MockAuthRepository();
    usecase = GetUser(repository: mockAuthRepository);
    tUserModel = UserModel.fromJSON(
      json.decode(fixture('user.json'))
    );
  });

  group('Get user use case', () { 
    test('Should return a model', () async {
      when(() => mockAuthRepository.getUser())
      .thenAnswer((_) async {
        return Right(tUserModel);
      });

      final result = await usecase(NoUserParams());

      expect(result, Right(tUserModel));
      verify(() => mockAuthRepository.getUser());
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
  
} 