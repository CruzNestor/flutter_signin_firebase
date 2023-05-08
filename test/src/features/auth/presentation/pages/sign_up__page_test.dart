import 'package:flutter/material.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sign_in_firebase_auth/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sign_in_firebase_auth/src/features/auth/presentation/pages/sign_up_page.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}
class FakeAuthState extends Fake implements AuthState {}

void main() {

  late MockAuthCubit mockAuthCubit;
  late AuthCubit authCubit;

  setUpAll(() async {
    mockAuthCubit = MockAuthCubit();
    final di = GetIt.instance;
    di.registerFactory<AuthCubit>(() => mockAuthCubit);
    authCubit = di<AuthCubit>();
  });

  group('SignUpPage', () {

    testWidgets('should show a button with text "Sign up"', (tester) async {
      when(() => authCubit.state)
      .thenAnswer((_) => FakeAuthState());

      await tester.pumpWidget(
        BlocProvider(
          create: (_) => authCubit,
          child: const MaterialApp(
            home: SignUpPage()
          ),
        )
      );

      expect(find.text('Sign up'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should show a button with CircularProgressIndicator', (tester) async {
      when(() => authCubit.state)
      .thenAnswer((_) => Authenticating());

      await tester.pumpWidget(
        BlocProvider(
          create: (_) => authCubit,
          child: const MaterialApp(
            home: SignUpPage()
          ),
        )
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Sign up'), findsNothing);
    });

  });
}