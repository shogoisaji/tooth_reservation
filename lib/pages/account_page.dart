import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tooth_reservation/models/logged_in_user.dart';
import 'package:tooth_reservation/services/auth_service.dart';
import 'package:tooth_reservation/states/state.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthService _authService = AuthService();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final userData = ref.watch(loggedInUserProvider);
    print('userData:${userData != null ? userData.email : ''}');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('アカウント'),
        Text('name:${userData != null ? userData.username : 'null'}'),
        Text('email:${userData != null ? userData.email : 'null'}'),
        Text('number:${userData != null ? userData.phoneNumber : 'null'}'),
        TextField(
          decoration: InputDecoration(
            labelText: 'new password',
          ),
          controller: _passwordController,
        ),
        ElevatedButton(
          child: Text('パスワードの変更'),
          onPressed: () async {
            await _authService.changePassword(
              _passwordController.text,
            );
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
        ),
      ],
    );
  }
}
