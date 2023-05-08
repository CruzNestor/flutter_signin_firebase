import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';


class SignIn implements UseCase<User, Credentials> {
  SignIn({required this.repository});
  final AuthRepository repository;

  @override
  Future<Either<Failure, User>> call(Credentials credentials) async {
    return await repository.signIn(email: credentials.email, password: credentials.password);
  }
}

class Credentials {
  Credentials({required this.email, required this.password});
  final String email;
  final String password;
}