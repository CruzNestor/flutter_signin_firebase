import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart' show sl;
import 'src/core/router/app_router.dart';
import 'src/features/auth/presentation/cubit/auth_cubit.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Firebase Auth',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue
        ),
        routerConfig: AppRouter.router
      )
    );
  }
}