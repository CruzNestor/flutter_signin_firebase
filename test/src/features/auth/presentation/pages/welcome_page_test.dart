import 'package:flutter/material.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sign_in_firebase_auth/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sign_in_firebase_auth/src/features/auth/presentation/pages/welcome_page.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}
class FakeAuthState extends Fake implements AuthState {}

void main() {

  group('WelcomePage', () {

    testWidgets('should show a FlutterLogo and buttons widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: WelcomePage()
        )
      );
      expect(find.byType(FlutterLogo), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
    });

  });
}