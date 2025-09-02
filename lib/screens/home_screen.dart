// home_screen.dart
import 'package:flutter/material.dart';
import 'rights_screen.dart';
import 'legal_aid_directory_screen.dart';
import 'legal_guides_screen.dart';
import 'report_screen.dart';
import 'favorites_screen.dart';
import 'admin_view_screen.dart'; // Import the AdminViewScreen

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
            _buildHomeCard(
              context,
              title: 'Fundamental Rights',
              icon: Icons.gavel,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RightsScreen(tableName: 'rights', updateFavoriteState: updateFavoriteState, favoriteStates: favoriteStates)),
              ),
            ),
            _buildHomeCard(
              context,
              title: 'Legal Aid Directory',
              icon: Icons.people,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LegalAidDirectoryScreen(tableName: 'legal_aids', updateFavoriteState: updateFavoriteState, favoriteStates: favoriteStates)),
              ),
            ),
            _buildHomeCard(
              context,
              title: 'Legal Guides',
              icon: Icons.menu_book,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LegalGuidesScreen(tableName: 'legal_guides', updateFavoriteState: updateFavoriteState,  favoriteStates: favoriteStates)),
              ),
            ),
            _buildHomeCard(
              context,
              title: 'Report Issues',
              icon: Icons.report,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportScreen()),
              ),
            ),
            _buildHomeCard(
              context,
              title: 'Favorites',
              icon: Icons.favorite,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen(favoriteStates: favoriteStates)),
              ),
            ),
            _buildHomeCard(
              context,
              title: 'Admin View',
              icon: Icons.settings,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminViewScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.blueAccent),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}