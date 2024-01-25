import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

// Email and password sign up
  Future<AuthResponse?> signUp(String email, String password) async {
    final AuthResponse res = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    return res;
  }

// Email and password login
  Future<String?> signIn(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(
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
    await supabase.auth.signOut();
  }
}
