import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';


class SignOut implements UseCase<bool, NoParams> {
  SignOut({required this.repository});
  final AuthRepository repository;

  @override
  Future<Either<Failure, bool>> call(NoParams noParams) async {
    return await repository.signOut();
  }
}

class NoParams {}