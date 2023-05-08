import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'src/core/platform/network_info.dart';
import 'src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'src/features/auth/data/repositories/auth_repository_impl.dart';
import 'src/features/auth/domain/repositories/auth_repository.dart';
import 'src/features/auth/domain/usecases/get_user.dart';
import 'src/features/auth/domain/usecases/sign_in.dart';
import 'src/features/auth/domain/usecases/sign_in_with_google.dart';
import 'src/features/auth/domain/usecases/sign_out.dart';
import 'src/features/auth/domain/usecases/sign_up.dart';
import 'src/features/auth/presentation/cubit/auth_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  initExternal();
  initCore();
  initAuthFeature();
}

void initExternal(){
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
}

void initCore(){
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl()
  );
}

void initAuthFeature() {
  // Cubit
  sl.registerFactory(
    () => AuthCubit(
      getUserUseCase: sl(),
      signInUseCase: sl(),
      signInWithGoogleUseCase: sl(),
      signOutUseCase: sl(),
      signUpUseCase: sl()
    )
  );

  // Use cases
  sl.registerLazySingleton(() => GetUser(repository: sl()));

  sl.registerLazySingleton(() => SignIn(repository: sl()));

  sl.registerLazySingleton(() => SignInWithGoogle(repository: sl()));

  sl.registerLazySingleton(() => SignOut(repository: sl()));

  sl.registerLazySingleton(() => SignUp(repository: sl()));

  // Respository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl(), networkInfo: sl())
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      googleSignIn: sl()
    )
  );
}