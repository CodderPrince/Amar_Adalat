// legal_guides_screen.dart
import 'package:flutter/material.dart';
import '../widgets/supabase_list.dart';

class LegalGuidesScreen extends StatelessWidget {
  final String tableName;
  final Function(String, String, bool)? updateFavoriteState;
  final Map<String, dynamic>? favoriteStates;

  const LegalGuidesScreen({Key? key, required this.tableName, this.updateFavoriteState, this.favoriteStates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract only the boolean values from the favoriteStates map
    Map<String, bool> extractedFavoriteStates = {};
    favoriteStates?.forEach((key, value) {
      extractedFavoriteStates[key] = value is Map ? (value['isFavorite'] as bool? ?? false) : value as bool? ?? false;
    });

    return SupabaseListScreen(
      tableName: tableName,
      titleField: 'title',
      subtitleField: 'description',
      appBarTitle: 'Legal Guides',
      updateFavoriteState: updateFavoriteState,
      favoriteStates: extractedFavoriteStates,
    );
  }
}