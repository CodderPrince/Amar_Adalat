import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

class SupabaseHelper {
  static Future<List<Map<String, dynamic>>> fetchTable(String tableName) async {
    try {
      final response = await supabase.from(tableName).select('*');
      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print("Supabase fetch error: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>?> fetchById(
      String tableName, String idField, dynamic id) async {
    try {
      final response =
      await supabase.from(tableName).select('*').eq(idField, id).single();
      return response as Map<String, dynamic>;
    } catch (e) {
      print("Supabase fetchById error: $e");
      return null;
    }
  }

  static Future<bool> insertData(
      String tableName, Map<String, dynamic> data) async {
    try {
      final response = await supabase.from(tableName).insert(data);
      return response != null;
    } catch (e) {
      print("Supabase insert error: $e");
      return false;
    }
  }
}
