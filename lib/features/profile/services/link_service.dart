import 'package:linkaty/features/profile/models/link_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LinkService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _tableName = 'Links';

  /// create link
  Future<bool> createLink(LinkModel link) async {
    try {
      await _supabase.from(_tableName).insert(link.toJson());
      return true;
    } catch (e) {
      print('Error creating link: $e');
      return false;
    }
  }

  Future<bool> updateLink(LinkModel link) async {
    try {
      if (link.id == null || link.id!.isEmpty) {
        throw Exception("Link ID is missing");
      }
      await _supabase.from(_tableName).update(link.toJson()).eq('id', link.id!);
      return true;
    } on PostgrestException catch (e) {
      print('Supabase Error: ${e.message}');
      return false;
    } catch (e) {
      print('Error updating link: $e');
      return false;
    }
  }

  /// Delete link
  Future<bool> deleteLink({required String id}) async {
    try {
      await _supabase.from(_tableName).delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting link: $e');
      return false;
    }
  }

  /// Stream all Links by user id

  Stream<List<LinkModel>> getAllLinksByUserId({required String userId}) {
    return Supabase.instance.client
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) {
          return data.map<LinkModel>((e) => LinkModel.fromJson(e)).toList();
        });
  }
}
