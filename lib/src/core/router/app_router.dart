import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'package:sign_in_firebase_auth/src/core/router/auth_notifier.dart';

import '../../../injection_container.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

import 'custom_transition.dart';


class AppRouter {

  static final notifier = AuthNotifier(sl<FirebaseAuth>());

  static final router = GoRouter(
    refreshListenable: notifier,
    redirect: (context, state) {
      if(notifier.isAuthenticated && (state.location == '/signin' || state.location == '/signup')){
        return '/home';
      } else if(!notifier.isAuthenticated && state.location != '/signin' && state.location != '/signup'){
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => buildPageWithTransition(
          child: notifier.isAuthenticated ? const HomePage() : const WelcomePage(),
          context: context,
          state: state
        )
      ),
      GoRoute(
        path: '/signin',
        pageBuilder: (context, state) => buildPageWithTransition(
          child: const SignInPage(),
          context: context,
          state: state
        )
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) => buildPageWithTransition(
          child: const SignUpPage(),
          context: context,
          state: state
        )
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => buildPageWithTransition(
          child: const HomePage(),
          context: context,
          state: state
        )
      )
    ]
  );
}