// legal_aid_directory_screen.dart
import 'package:flutter/material.dart';
import '../widgets/supabase_list.dart';

class LegalAidDirectoryScreen extends StatelessWidget {
  final String tableName;
  final Function(String, String, bool)? updateFavoriteState;
  final Map<String, bool>? favoriteStates;

  const LegalAidDirectoryScreen({Key? key, required this.tableName, this.updateFavoriteState, this.favoriteStates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SupabaseListScreen(
      tableName: tableName,
      titleField: 'name',
      subtitleField: 'address',
      appBarTitle: 'Legal Aid Directory',
      updateFavoriteState: updateFavoriteState,
      favoriteStates: favoriteStates,
    );
  }
}