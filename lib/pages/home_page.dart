import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tooth_reservation/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text('ホーム'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _authService.signOut();
              // ログアウトロジックをここに追加
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'Hello, world!',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          ElevatedButton(
            child: Text('予約'),
            onPressed: () {
              context.go('/home/reservation');
              // ログアウトロジックをここに追加
            },
          ),
        ],
      ),
    );
  }
}
