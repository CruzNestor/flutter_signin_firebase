import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';


abstract class AuthRepository {
  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, User>> signIn({required String email, required String password});
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, bool>> signOut();
  Future<Either<Failure, User>> signUp({required String email, required String name, required String password});
}