import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';

class FavoritesService {
  final supabase = Supabase.instance.client;

  // Add a favorite
  Future<void> addFavorite({
    required String tableName,
    required int itemId,
    required String userId,
  }) async {
    await supabase.from('favorites').insert({
      'user_id': userId,
      'table_name': tableName,
      'item_id': itemId,
    });
  }

  // Remove a favorite
  Future<void> removeFavorite({
    required String tableName,
    required int itemId,
    required String userId,
  }) async {
    await supabase
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('table_name', tableName)
        .eq('item_id', itemId);
  }

  // Fetch all favorites for a user
  Future<List<Map<String, dynamic>>> fetchFavorites(String userId) async {
    final favs = await supabase
        .from('favorites')
        .select('item_id, table_name')
        .eq('user_id', userId);

    final List<Map<String, dynamic>> result = [];
    for (var fav in favs) {
      final item = await supabase
          .from(fav['table_name'])
          .select('*')
          .eq('id', fav['item_id'])
          .maybeSingle();
      if (item != null) result.add(item);
    }
    return result;
  }

  // Check if an item is favorited
  Future<bool> isFavorite({
    required String tableName,
    required int itemId,
    required String userId,
  }) async {
    final response = await supabase
        .from('favorites')
        .select('id')
        .eq('user_id', userId)
        .eq('table_name', tableName)
        .eq('item_id', itemId)
        .maybeSingle();
    return response != null;
  }
}