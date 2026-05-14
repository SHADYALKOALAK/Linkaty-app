import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseUploadService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> uploadFile({
    required File file,
    required String bucket,
    required String folder,
  }) async {
    try {
      if (!await file.exists()) {
        throw Exception('الملف غير موجود');
      }

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}';

      final filePath = '$folder/$fileName';

      await _supabase.storage
          .from(bucket)
          .upload(filePath, file, fileOptions: const FileOptions(upsert: true));

      final publicUrl = _supabase.storage.from(bucket).getPublicUrl(filePath);

      return publicUrl;
    } on StorageException catch (e) {
      print('Storage Error: ${e.message}');
      return null;
    } catch (e) {
      print('Upload Error: $e');
      return null;
    }
  }
}
