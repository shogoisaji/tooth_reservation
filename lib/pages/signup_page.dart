import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tooth_reservation/repositories/supabase/supabase_auth_repository.dart';

class SignUpPage extends HookConsumerWidget {
  SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _emailController = useTextEditingController();
    final TextEditingController _passwordController1 = useTextEditingController();
    final TextEditingController _passwordController2 = useTextEditingController();
    final TextEditingController _userNameController = useTextEditingController();
    final TextEditingController _phoneNumberController = useTextEditingController();

    final _authService = ref.read(supabaseAuthRepositoryProvider);
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    requiredLabel(),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: '名前',
                        ),
                        controller: _userNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '名前は必須です。';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    requiredLabel(),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'メール',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'メールは必須です。';
                          }
                          return null;
                        },
                        controller: _emailController,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    optionalLabel(),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: '電話番号',
                        ),
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    requiredLabel(),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'パスワード',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'パスワードは必須です。';
                          }
                          return null;
                        },
                        obscureText: true,
                        controller: _passwordController1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    requiredLabel(),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'パスワード確認',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'パスワード確認は必須です。';
                          }
                          if (value != _passwordController1.value.text) {
                            return 'パスワード確認が正しくありません。';
                          }
                          return null;
                        },
                        obscureText: true,
                        controller: _passwordController2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                    child: const Text('サインアップ'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final String? error = await _authService.signUp(_emailController.text,
                            _passwordController1.text, _userNameController.text, _phoneNumberController.text);
                        if (error == null) {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('仮登録が完了しました。'),
                                  content: const Text('Eメールを確認して本登録を完了してください。'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _emailController.clear();
                                        _passwordController1.clear();
                                        _passwordController2.clear();
                                        _userNameController.clear();
                                        _phoneNumberController.clear();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } else {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('エラー'),
                                  content: Text(error),
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
                          print('signup error:${error}');
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget requiredLabel() {
  return Container(
    margin: const EdgeInsets.only(top: 10.0),
    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
    decoration: BoxDecoration(
      color: Colors.red[400],
      borderRadius: BorderRadius.circular(5),
    ),
    child: const Center(
      child: Text(
        '必須',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    ),
  );
}

Widget optionalLabel() {
  return Container(
    margin: const EdgeInsets.only(top: 10.0),
    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(5),
    ),
    child: const Center(
      child: Text(
        '任意',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    ),
  );
}
