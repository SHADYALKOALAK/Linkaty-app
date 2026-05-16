import 'package:linkaty/features/profile/models/project_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProjectService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _tableName = 'Projects';

  /// create project
  Future<bool> createProject(ProjectModel project) async {
    try {
      await _supabase.from(_tableName).insert(project.toJson());
      return true;
    } catch (e) {
      print('Error creating project: $e');
      return false;
    }
  }

  Future<bool> updateProject(ProjectModel project) async {
    try {
      if (project.id == null || project.id!.isEmpty) {
        throw Exception("User ID is missing");
      }
      await _supabase
          .from(_tableName)
          .update(project.toJson())
          .eq('id', project.id!);
      return true;
    } on PostgrestException catch (e) {
      print('Supabase Error: ${e.message}');
      return false;
    } catch (e) {
      print('Error updating project: $e');
      return false;
    }
  }

  /// Delete project
  Future<bool> deleteProject({required String id}) async {
    try {
      await _supabase.from(_tableName).delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting project: $e');
      return false;
    }
  }

  /// Stream all projects by user id

  Stream<List<ProjectModel>> getAllProjectsByUserId({required String userId}) {
    return Supabase.instance.client
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) {
          return data
              .map<ProjectModel>((e) => ProjectModel.fromJson(e))
              .toList();
        });
  }

  /// Get all projects by user id

  Future<List<ProjectModel>> getAllProjectsByUserIdOnce({
    required String id,
  }) async {
    final response = await _supabase
        .from(_tableName)
        .select()
        .eq('user_id', id);

    return response.map<ProjectModel>((e) => ProjectModel.fromJson(e)).toList();
  }
}
