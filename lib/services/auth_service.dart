import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

// Email and password sign up
  Future<String?> signUp(String email, String password, String username, String? phoneNumber) async {
    try {
      await supabase.auth
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

// change password
  Future<void> changePassword(newPassword) async {
    final UserResponse res = await supabase.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );
    final User? updatedUser = res.user;
    print('success update user');
  }

// reset password
  Future<void> resetPassword() async {
    await supabase.auth.reauthenticate();
  }
}
