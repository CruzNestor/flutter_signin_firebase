import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


CustomTransitionPage buildPageWithTransition<T>({
  required BuildContext context, 
  required GoRouterState state, 
  required Widget child,
}) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;
  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => 
      SlideTransition(position: animation.drive(tween), child: child)
  );
}