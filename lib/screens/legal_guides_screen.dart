import 'package:flutter/material.dart';
import '../widgets/supabase_list.dart';

class LegalGuidesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SupabaseListScreen(
      tableName: 'legal_guides',
      titleField: 'title',
      subtitleField: 'description',
      appBarTitle: 'Legal Guides',
    );
  }
}
