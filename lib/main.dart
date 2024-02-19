import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tooth_reservation/models/settings/load_setting_data.dart';
import 'package:tooth_reservation/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:tooth_reservation/routes/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tooth_reservation/states/app_state.dart';
import 'package:tooth_reservation/widgets/loading.dart';

void main() async {
  late final SharedPreferences sharedPreferences;
  WidgetsFlutterBinding.ensureInitialized();
  // 画面の向きを固定.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await (
    Supabase.initialize(
      url: 'https://emyvxrksyrammrfvtmwz.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVteXZ4cmtzeXJhbW1yZnZ0bXd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDYxNDY1MzMsImV4cCI6MjAyMTcyMjUzM30.Am76wdLi1i21e7nV2-8HtcoKE1T_INh8B2Nn8hmnShc',
    ),
    Future(() async {
      sharedPreferences = await SharedPreferences.getInstance();
    })
  ).wait;

  const app = MyApp();
  final scope = ProviderScope(overrides: [
    sharedPreferencesRepositoryProvider.overrideWithValue(SharedPreferencesRepository(sharedPreferences)),
  ], child: app);
  runApp(scope);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(loadSettingDataProvider.notifier).load();
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      theme: ThemeData(fontFamily: 'M PLUS Rounded 1c'),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
