import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tooth_reservation/repositories/supabase/supabase_auth_repository.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _emailController = useTextEditingController();
    final TextEditingController _passwordController = useTextEditingController();

    final _authService = ref.read(supabaseAuthRepositoryProvider);

    useEffect(() {
      if (_authService.authUser != null) {
        context.go('/home');
      }
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'メール',
                  ),
                  controller: _emailController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return '必須';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'パスワード',
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return '必須';
                    }
                    if (val.length < 6) {
                      return '6文字以上';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                    child: const Text('ログイン'),
                    onPressed: () async {
                      final res = await _authService.signIn(
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (res != null && context.mounted) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('エラー'),
                              content: Text(res),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }),
                const SizedBox(height: 12.0),
                TextButton(
                  child: const Text('Sign Up'),
                  onPressed: () {
                    context.go('/login/signup');
                  },
                ),
                TextButton(
                  child: const Text('パスワードを忘れましたか？'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('パスワードを忘れましたか？'),
                          content: const Text('パスワードをリセットするためのリンクを送信します。'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('キャンセル'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                await _authService.resetPassword();
                                if (context.mounted) Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ElevatedButton(
                  child: const Text('ログインしなで利用'),
                  onPressed: () {
                    context.go('/home');
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
