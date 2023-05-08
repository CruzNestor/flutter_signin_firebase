import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sign_in_firebase_auth/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:sign_in_firebase_auth/src/features/auth/domain/usecases/sign_out.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignOut usecase;

  setUp((){
    mockAuthRepository = MockAuthRepository();
    usecase = SignOut(repository: mockAuthRepository);
  });

  group('Sign out use case', () {

    test('Should return true', () async {
      when(() => mockAuthRepository.signOut())
      .thenAnswer((_) async => const Right(true));

      final result = await usecase(NoParams());

      expect(result, const Right(true));
      verify(() => mockAuthRepository.signOut());
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });

} 