// lib/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<AuthResponse> signUp(String email, String password) async {
    try {
      return await supabase.auth.signUp(email: email, password: password);
    } catch (e) {
      print('Error during sign up: $e');
      throw e; // Re-throw the error to be caught in the UI
    }
  }

  Future<AuthResponse> signIn(String email, String password) async {
    try {
      return await supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      print('Error during sign in: $e');
      throw e; // Re-throw the error to be caught in the UI
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      print('Error during sign out: $e');
      throw e; // Re-throw the error to be caught in the UI
    }
  }

  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }
}