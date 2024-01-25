import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tooth_reservation/pages/home_page.dart';
import 'package:tooth_reservation/pages/login_page.dart';
import 'package:tooth_reservation/pages/reservation_page.dart';
import 'package:tooth_reservation/states/state.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final bool _isLogin = ref.watch(userProvider) != null;
  final routes = [
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: [
        GoRoute(
          path: 'reservation',
          builder: (BuildContext context, GoRouterState state) {
            return Scaffold(
              appBar: AppBar(title: Text('Second')),
              body: const ReservationPage(),
            );
          },
        ),
      ],
    ),
  ];

  return GoRouter(
    initialLocation: _isLogin ? '/home' : '/login',
    routes: routes,
  );
}
