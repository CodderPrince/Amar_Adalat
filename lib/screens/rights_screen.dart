import 'package:flutter/material.dart';
import '../widgets/supabase_list.dart';

class RightsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SupabaseListScreen(
      tableName: 'rights',
      titleField: 'title',
      subtitleField: 'description',
      appBarTitle: 'Fundamental Rights',
    );
  }
}
