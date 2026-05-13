import 'package:linkaty/features/auth/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _tableName = 'Users';

  /// Create a new user in the database.
  Future<bool> createUser(UserModel user) async {
    try {
      await _supabase.from(_tableName).insert(user.toJson());
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  /// Get a user by ID.
  Future<UserModel> getUserById(String id) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', id)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      print('Error getting user by id: $e');
      rethrow;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final data = await _supabase
          .from(_tableName)
          .select();

      return data
          .map<UserModel>((e) => UserModel.fromJson(e))
          .toList();
    } catch (e) {
      print('Error getting users: $e');
      rethrow;
    }
  }

  /// Update user
  Future<bool> updateUser(UserModel user) async {
    try {
      await _supabase
          .from(_tableName)
          .update(user.toJson())
          .eq('id', user.id ?? '');

      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  /// Delete user
  Future<bool> deleteUser(String id) async {
    try {
      await _supabase.from(_tableName).delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

}