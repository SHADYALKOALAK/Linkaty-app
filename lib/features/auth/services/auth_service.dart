import 'package:linkaty/features/auth/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signUp(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> checkEmailExists(String email) async {
    final response = await _supabase
        .from('Users')
        .select('id')
        .eq('email', email)
        .maybeSingle();

    return response != null;
  }

  Future<bool> resetPassword({required String email}) async {
    final exists = await checkEmailExists(email);

    if (!exists) {
      return false;
    }

    await _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: 'com.linkaty.app://login-callback',
    );

    return true;
  }
  Future<bool> updatePassword({required String newPassword}) async {
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );

      print('Password updated successfully');
      return true;
    } catch (e) {
      print('Update Password Error: $e');
      return false;
    }
  }}
