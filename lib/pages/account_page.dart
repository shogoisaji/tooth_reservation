import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tooth_reservation/services/auth_service.dart';
import 'package:tooth_reservation/states/state.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthService _authService = AuthService();
    final TextEditingController _passwordController = TextEditingController();
    final userData = ref.watch(loggedInUserProvider);

    return userData != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('アカウント'),
              Text('name:${userData.username}'),
              Text('email:${userData.email}'),
              Text('number:${userData.phoneNumber}'),
              TextField(
                decoration: InputDecoration(
                  labelText: 'new password',
                ),
                controller: _passwordController,
              ),
              ElevatedButton(
                child: Text('パスワードの変更'),
                onPressed: () async {
                  //
                },
              ),
              ElevatedButton(
                child: Text('Eメールの変更'),
                onPressed: () {
                  // サインアップロジックをここに追加
                },
              ),
              ElevatedButton(
                child: Text('ログアウト'),
                onPressed: () {
                  _authService.signOut();
                },
              )
            ],
          )
        : Center(
            child: ElevatedButton(
              child: Text('ログインページ'),
              onPressed: () {
                context.go('/login');
              },
            ),
          );
  }
}
