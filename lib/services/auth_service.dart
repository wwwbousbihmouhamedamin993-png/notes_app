import 'package:supabase_flutter/supabase_flutter.dart';

/// Service class to handle authentication logic using Supabase.
class AuthService {
  /// Supabase client authentication instance.
  final supabase = Supabase.instance.client.auth;

  /// Signs up a new user with the provided [email] and [password].
  Future<void> signUp(String email, String password) async {
    await supabase.signUp(email: email, password: password);
  }

  /// Signs in an existing user with the provided [email] and [password].
  Future<void> signIn(String email, String password) async {
    await supabase.signInWithPassword(email: email, password: password);
  }

  /// Signs out the currently authenticated user.
  Future<void> signOut() async {
    await supabase.signOut();
  }

  /// Returns the currently authenticated [User], if any.
  User? get currrentUser {
    return supabase.currentUser;
  }
}
