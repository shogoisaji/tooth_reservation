import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tooth_reservation/pages/account_page.dart';
import 'package:tooth_reservation/pages/home_page.dart';
import 'package:tooth_reservation/pages/login_page.dart';
import 'package:tooth_reservation/pages/reservation_form.dart';
import 'package:tooth_reservation/pages/reservation_page.dart';
import 'package:tooth_reservation/pages/signup_page.dart';
import 'package:tooth_reservation/repositories/supabase/supabase_auth_repository.dart';
import 'package:tooth_reservation/theme/color_theme.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final Session? session = ref.watch(sessionStateProvider);
  final String? loggedInUser = session != null ? session.user.userMetadata!['user_name'] : null;
  final routes = [
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return Scaffold(
            backgroundColor: const Color(MyColor.mint4),
            appBar: AppBar(
              backgroundColor: const Color(MyColor.mint1),
              title:
                  const Text('ログイン', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            body: const LoginPage());
      },
      routes: [
        GoRoute(
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return Scaffold(
              backgroundColor: const Color(MyColor.mint4),
              appBar: AppBar(title: const Text('サインアップ')),
              body: SignUpPage(),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return Scaffold(
          backgroundColor: const Color(MyColor.mint1),
          appBar: AppBar(
            title: const Text('ホーム', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            backgroundColor: const Color(MyColor.mint1),
            actions: [
              Row(
                children: [
                  Text(loggedInUser ?? '未ログイン'),
                  IconButton(
                    icon: const Icon(Icons.account_circle),
                    padding: const EdgeInsets.only(right: 12.0),
                    onPressed: () {
                      context.go('/home/account');
                    },
                  ),
                ],
              ),
            ],
          ),
          body: const HomePage(),
        );
      },
      routes: [
        GoRoute(
          path: 'reservation',
          builder: (BuildContext context, GoRouterState state) {
            return Scaffold(
              backgroundColor: const Color(MyColor.mint2),
              appBar: AppBar(
                title:
                    const Text('予約', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                backgroundColor: const Color(MyColor.mint1),
                leading: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.chevronLeft, color: Colors.white),
                  onPressed: () => GoRouter.of(context).pop(),
                ),
              ),
              body: const ReservationPage(),
            );
          },
          routes: [
            GoRoute(
              path: 'reservation_form',
              builder: (BuildContext context, GoRouterState state) {
                return Scaffold(
                  backgroundColor: const Color(MyColor.mint4),
                  appBar: AppBar(
                      title: const Text('予約フォーム',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      backgroundColor: const Color(MyColor.mint1),
                      leading: IconButton(
                        icon: const FaIcon(FontAwesomeIcons.chevronLeft, color: Colors.white),
                        onPressed: () => GoRouter.of(context).pop(),
                      )),
                  body: const ReservationFormPage(),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'account',
          builder: (BuildContext context, GoRouterState state) {
            return Scaffold(
              backgroundColor: const Color(MyColor.mint4),
              appBar: AppBar(
                backgroundColor: const Color(MyColor.mint1),
                title: const Text('アカウント',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                leading: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.chevronLeft, color: Colors.white),
                  onPressed: () => GoRouter.of(context).pop(),
                ),
              ),
              body: const AccountPage(),
            );
          },
        ),
      ],
    ),
  ];

  return GoRouter(
    initialLocation: session != null ? '/home' : '/login',
    routes: routes,
  );
}
