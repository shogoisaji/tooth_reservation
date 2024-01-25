import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tooth_reservation/services/auth_service.dart';
import 'package:tooth_reservation/states/state.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    final AuthService _authService = AuthService();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'メール',
                ),
                controller: _emailController,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'パスワード',
                ),
                obscureText: true,
                controller: _passwordController,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('サインアップ'),
                onPressed: () async {
                  final res = await _authService.signUp(
                    _emailController.text,
                    _passwordController.text,
                  );
                  print('session:${res?.session} user:${res?.user}');
                  // サインアップロジックをここに追加
                },
              ),
              ElevatedButton(
                child: Text('ログイン'),
                onPressed: () async {
                  final res = await _authService.signIn(
                    _emailController.text,
                    _passwordController.text,
                  );
                  print('login error:${res}');
                  // サインアップロジックをここに追加
                },
              ),
              TextButton(
                child: Text('ログインしていませんか？'),
                onPressed: () {
                  // ログインページへのリダイレクトロジックをここに追加
                },
              ),
              TextButton(
                child: Text('パスワードを忘れましたか？'),
                onPressed: () {
                  // パスワードリセットロジックをここに追加
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
