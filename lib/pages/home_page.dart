import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tooth_reservation/states/state.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(loggedInUserProvider)?.username ?? '未ログイン';

    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
        actions: [
          Row(
            children: [
              Text(userName),
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
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text('予約'),
              onPressed: () {
                context.go('/home/reservation');
              },
            ),
          ],
        ),
      ),
    );
  }
}
