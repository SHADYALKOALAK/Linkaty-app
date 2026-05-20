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
      final response =
          await _supabase.from(_tableName).select().eq('id', id).single();

      return UserModel.fromJson(response);
    } catch (e) {
      print('Error getting user by id: $e');
      rethrow;
    }
  }

  /// Get a user by email.
  Future<UserModel> getUserByEmail({required String email}) async {
    try {
      final response =
          await _supabase.from(_tableName).select().eq('email', email).single();

      return UserModel.fromJson(response);
    } catch (e) {
      print('Error getting user by id: $e');
      rethrow;
    }
  }

  Stream<List<UserModel>> getAllUsers() {
    return _supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .map((data) => data.map((e) => UserModel.fromJson(e)).toList());
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      if (user.id == null || user.id!.isEmpty) {
        throw Exception("User ID is missing");
      }
      final response = await _supabase
          .from(_tableName)
          .update(user.toJson())
          .eq('id', user.id!);
      print("UPDATE RESPONSE = $response");

      return true;
    } on PostgrestException catch (e) {
      print('Supabase Error: ${e.message}');
      return false;
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

  /// Get active users only
  Future<List<UserModel>> getAllUsersOnce() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('is_profile_active', true);

      return response
          .map<UserModel>((e) => UserModel.fromJson(e))
          .toList();
    } catch (e) {
      print('Error getting all users: $e');
      rethrow;
    }
  }
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final response = await _supabase
          .from('Users')
          .select('''
          id,
          fullName,
          image,
          location,
          bio,
          specialization,
          isVerified,
          typeOfJop
        ''')
          .eq('is_profile_active', true)
          .ilike('fullName', '%$query%');

      final data = response as List;

      return data.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }
}
