import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart';
import 'package:tooth_reservation/models/logged_in_user.dart';

part 'state.g.dart';

@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

@riverpod
Stream<Session?> sessionResponse(SessionResponseRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange.map((event) => event.session);
}

@riverpod
User? loggedInUserData(LoggedInUserDataRef ref) {
  final session = ref.watch(sessionResponseProvider);
  return session.when(
    loading: () => null,
    error: (_, __) => null,
    data: (d) => d?.user,
  );
}

@riverpod
LoggedInUser? loggedInUser(LoggedInUserRef ref) {
  final User? userData = ref.watch(loggedInUserDataProvider);
  if (userData == null) {
    return null;
  }
  return LoggedInUser(
    username: userData.userMetadata!['user_name'],
    email: userData.email ?? '',
    phoneNumber: userData.userMetadata!['phone_number'] ?? '電話番号未登録',
  );
}

@riverpod
class DetailSelectState extends _$DetailSelectState {
  @override
  bool build() => false;

  void show() => state = true;

  void hide() => state = false;
}
