import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart';

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
User? user(UserRef ref) {
  final session = ref.watch(sessionResponseProvider);
  return session.when(
    loading: () => null,
    error: (_, __) => null,
    data: (d) => d?.user,
  );
}
