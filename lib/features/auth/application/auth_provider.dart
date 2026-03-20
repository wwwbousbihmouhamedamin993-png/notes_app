import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:notes_app/features/auth/data/auth_service.dart';

/// Provider that exposes an [AuthService] instance.
final authServiceProvieder = Provider<AuthService>(
  (ref) {
    return AuthService();
  },
);

/// A notifier that manages the current user state and handles authentication actions.
class AuthNotifier extends Notifier<User?> {
  @override
  User? build() {
    /// Initialize the state with the currently logged-in user from [AuthService].
    return ref.read(authServiceProvieder).currrentUser;
  }

  /// Signs up a new user and updates the current state.
  ///
  /// Returns an error string if the sign-up fails, otherwise returns null.
  Future<String?> signUp(String email, String password) async {
    try {
      await ref.read(authServiceProvieder).signUp(email, password);
      state = ref.read(authServiceProvieder).currrentUser;
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Signs in a user and updates the current state.
  ///
  /// Returns an error string if the sign-in fails, otherwise returns null.
  Future<String?> signIn(String email, String password) async {
    try {
      await ref.read(authServiceProvieder).signIn(email, password);
      state = ref.read(authServiceProvieder).currrentUser;
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Signs out the current user and resets the state to null.
  Future<void> signOut() async {
    await ref.read(authServiceProvieder).signOut();
    state = null;
  }
}

/// Provider instance for [AuthNotifier].
final authProvider = NotifierProvider<AuthNotifier, User?>(
  () {
    return AuthNotifier();
  },
);
