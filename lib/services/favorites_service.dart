import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';

class FavoritesService {
  final supabase = Supabase.instance.client;

  // Add a favorite
  Future<void> addFavorite({
    required String tableName,
    required int itemId,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      await supabase.from('favorites').insert({
        'user_id': userId,
        'table_name': tableName,
        'item_id': itemId,
      });
    } catch (error) {
      print(error);
      throw Exception('Something went wrong when adding favourite, check console.');
    }
  }

  // Remove a favorite
  Future<void> removeFavorite({
    required String tableName,
    required int itemId,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      await supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('table_name', tableName)
          .eq('item_id', itemId);
    } catch (error) {
      print(error);
      throw Exception('Something went wrong when removing favourite, check console.');
    }
  }

  // Fetch all favorites for a user
  Future<List<Map<String, dynamic>>> fetchFavorites() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      final favs = await supabase
          .from('favorites')
          .select('item_id, table_name')
          .eq('user_id', userId);

      return (favs as List).cast<Map<String, dynamic>>();
    } catch (error) {
      print(error);
      throw Exception('Something went wrong when fetching favourites, check console.');
    }
  }

  // Check if an item is favorited
  Future<bool> isFavorite({
    required String tableName,
    required int itemId,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      return false;
    }

    try {
      final response = await supabase
          .from('favorites')
          .select('id')
          .eq('user_id', userId)
          .eq('table_name', tableName)
          .eq('item_id', itemId)
          .maybeSingle();
      return response != null;
    } catch (error) {
      print(error);
      throw Exception('Something went wrong when verifying favourite, check console.');
    }
  }
}