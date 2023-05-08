import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/platform/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

typedef FunctionUserType = Future<User> Function();


class AuthRepositoryImpl implements AuthRepository {

  AuthRepositoryImpl({
    required this.networkInfo,
    required this.remote
  });

  final AuthRemoteDataSource remote;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, User>> getUser() async {
    return await validation((){
      return remote.getUser();
    });
  }

  @override
  Future<Either<Failure, User>> signIn({required String email, required String password}) async {
    return await validation((){
      return remote.signIn(email: email, password: password);
    });
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    return await validation((){
      return remote.signInWithGoogle();
    });
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    if(await networkInfo.isConnected) {
      try {
        final data = await remote.signOut();
        return Right(data);
      } on fa.FirebaseAuthException catch (e) {
        return Left(ServerFailure('${e.message}'));
      }
    }
    return const Left(NetworkConnectionFailure(CONNECTION_FAILURE_MESSAGE));
  }

  @override
  Future<Either<Failure, User>> signUp({required String email, required String name, required String password}) async {
    return await validation((){
      return remote.signUp(email: email, name: name, password: password);
    });
  }

  Future<Either<Failure, User>> validation(FunctionUserType call) async {
    if(await networkInfo.isConnected) {
      try {
        final data = await call();
        return Right(data);
      } on fa.FirebaseAuthException catch (e) {
        return Left(ServerFailure('${e.message}'));
      } on CustomException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('$e'));
      }
    }
    return const Left(NetworkConnectionFailure(CONNECTION_FAILURE_MESSAGE));
  }

}