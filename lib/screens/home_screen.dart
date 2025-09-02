// home_screen.dart
import 'package:flutter/material.dart';
import 'rights_screen.dart';
import 'legal_aid_directory_screen.dart';
import 'legal_guides_screen.dart';
import 'report_screen.dart';
import 'favorites_screen.dart';
import 'admin_view_screen.dart'; // Import the AdminViewScreen
import '../widgets/card_item.dart'; // Import the HomeCard widget

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // This map will hold the favorite status for each item, keyed by a unique identifier
  Map<String, bool> favoriteStates = {};

  // Callback function to update the favorite state from SupabaseListScreen
  void updateFavoriteState(String tableName, String itemId, bool isFavorite) {
    setState(() {
      favoriteStates['$tableName-$itemId'] = isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Amar Adalat'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            HomeCard(
              title: 'Fundamental Rights',
              icon: Icons.gavel,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RightsScreen(tableName: 'rights', updateFavoriteState: updateFavoriteState, favoriteStates: favoriteStates)),
              ),
              backgroundColor: Colors.blueAccent, // Unique color
            ),
            HomeCard(
              title: 'Legal Aid Directory',
              icon: Icons.people,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LegalAidDirectoryScreen(tableName: 'legal_aids', updateFavoriteState: updateFavoriteState, favoriteStates: favoriteStates)),
              ),
              backgroundColor: Colors.green, // Unique color
            ),
            HomeCard(
              title: 'Legal Guides',
              icon: Icons.menu_book,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LegalGuidesScreen(tableName: 'legal_guides', updateFavoriteState: updateFavoriteState, favoriteStates: favoriteStates)),
              ),
              backgroundColor: Colors.orange, // Unique color
            ),
            HomeCard(
              title: 'Report Issues',
              icon: Icons.report,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportScreen()),
              ),
              backgroundColor: Colors.redAccent, // Unique color
            ),
            HomeCard(
              title: 'Favorites',
              icon: Icons.favorite,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen(favoriteStates: favoriteStates)),
              ),
              backgroundColor: Colors.purple, // Unique color
            ),
            HomeCard(
              title: 'Admin View',
              icon: Icons.settings,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminViewScreen()),
              ),
              backgroundColor: Colors.grey, // Unique color
            ),
          ],
        ),
      ),
    );
  }
}