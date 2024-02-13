import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tooth_reservation/repositories/supabase/supabase_auth_repository.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authService = ref.read(supabaseAuthRepositoryProvider);
    final userData = _authService.authUser;
    final TextEditingController _passwordController = useTextEditingController();

    return userData != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('アカウント'),
              // Text('name:${userData.username}'),
              Text('email:${userData.email}'),
              // Text('number:${userData.phoneNumber}'),
              TextField(
                decoration: const InputDecoration(
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
