import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tooth_reservation/models/settings/load_setting_data.dart';
import 'package:tooth_reservation/routes/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 画面の向きを固定.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Supabase.initialize(
    url: 'https://emyvxrksyrammrfvtmwz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVteXZ4cmtzeXJhbW1yZnZ0bXd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDYxNDY1MzMsImV4cCI6MjAyMTcyMjUzM30.Am76wdLi1i21e7nV2-8HtcoKE1T_INh8B2Nn8hmnShc',
  );
  const app = MyApp();
  const scope = ProviderScope(child: app);
  runApp(scope);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    ref.read(loadSettingDataProvider.notifier).load();
    return MaterialApp.router(
      theme: ThemeData(fontFamily: 'M PLUS Rounded 1c'),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
