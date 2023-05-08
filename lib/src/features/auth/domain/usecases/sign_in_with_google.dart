import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';


class SignInWithGoogle implements UseCase<User, NoCredentials> {
  SignInWithGoogle({required this.repository});
  final AuthRepository repository;

  @override
  Future<Either<Failure, User>> call(NoCredentials noCredentials) async {
    return await repository.signInWithGoogle();
  }
}

class NoCredentials {}