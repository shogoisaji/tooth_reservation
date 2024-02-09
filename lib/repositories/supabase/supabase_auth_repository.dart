import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supabase_auth_repository.g.dart';

@Riverpod(keepAlive: true)
SupabaseAuthRepository supabaseAuthRepository(SupabaseAuthRepositoryRef ref) {
  return SupabaseAuthRepository(Supabase.instance.client);
}

class SupabaseAuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  User? get authUser => _client.auth.currentUser;

// Email and password sign up
  Future<String?> signUp(String email, String password, String username, String? phoneNumber) async {
    try {
      await _client.auth
          .signUp(email: email, password: password, data: {"user_name": username, "phone_number": phoneNumber});
      return null;
    } on AuthException catch (er) {
      print(er.message);
      return er.message;
    } catch (err) {
      return err.toString();
    }
  }

// Email and password login
  Future<String?> signIn(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return null;
    } on AuthException catch (er) {
      print(er.message);
      return er.message;
    } catch (err) {
      return err.toString();
    }
  }

// Sign out
  void signOut() async {
    await _client.auth.signOut();
  }

// reset password
  Future<void> resetPassword() async {
    await _client.auth.reauthenticate();
  }
}
