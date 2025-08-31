import 'package:flutter/material.dart';
import '../widgets/supabase_list.dart';

class LegalAidDirectoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SupabaseListScreen(
      tableName: 'legal_aids',
      titleField: 'name',
      subtitleField: 'address',
      appBarTitle: 'Legal Aid Directory',
    );
  }
}
