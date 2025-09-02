// legal_guides_screen.dart
import 'package:flutter/material.dart';
import '../widgets/supabase_list.dart';

class LegalGuidesScreen extends StatelessWidget {
  final String tableName;
  final Function(String, String, bool)? updateFavoriteState;
  final Map<String, bool>? favoriteStates;

  const LegalGuidesScreen({Key? key, required this.tableName, this.updateFavoriteState, this.favoriteStates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SupabaseListScreen(
      tableName: tableName,
      titleField: 'title',
      subtitleField: 'description',
      appBarTitle: 'Legal Guides',
      updateFavoriteState: updateFavoriteState,
      favoriteStates: favoriteStates,
    );
  }
}