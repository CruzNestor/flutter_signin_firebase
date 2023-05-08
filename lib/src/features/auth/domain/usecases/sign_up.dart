import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';


class SignUp implements UseCase<User, SignUpForm> {
  SignUp({required this.repository});
  final AuthRepository repository;

  @override
  Future<Either<Failure, User>> call(SignUpForm form) async {
    return await repository.signUp(
      email: form.email, 
      name: form.name, 
      password: form.password
    );
  }
}

class SignUpForm {
  SignUpForm({
    required this.email,
    required this.name,
    required this.password
  });
  final String email;
  final String name;
  final String password;
}