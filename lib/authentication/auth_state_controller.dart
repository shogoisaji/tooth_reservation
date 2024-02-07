import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tooth_reservation/repositories/supabase/supabase_auth_repository.dart';

part 'auth_state_controller.g.dart';

/// 認証状態
enum AuthState {
  /// サインインしていない
  noSignIn,

  /// 匿名認証
  // signInWithAnonymously,

  /// サインインしている
  signIn;

  bool get isSignIn => this != noSignIn;
}

@Riverpod(keepAlive: true)
class AuthStateController extends _$AuthStateController {
  @override
  AuthState build() {
    final repository = ref.watch(supabaseAuthRepositoryProvider);
    final _isLoggedIn = repository.authUser;
    return _isLoggedIn != null ? AuthState.signIn : AuthState.noSignIn;
  }

  void update(AuthState authState) {
    state = authState;
  }
}
