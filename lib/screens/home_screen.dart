import 'package:flutter/material.dart';
import 'rights_screen.dart';
import 'legal_aid_directory_screen.dart';
import 'legal_guides_screen.dart';
import 'report_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatelessWidget {
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
                MaterialPageRoute(builder: (context) => RightsScreen()),
              ),
            ),
            _buildHomeCard(
              context,
              title: 'Legal Aid Directory',
              icon: Icons.people,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LegalAidDirectoryScreen()),
              ),
            ),
            _buildHomeCard(
              context,
              title: 'Legal Guides',
              icon: Icons.menu_book,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LegalGuidesScreen()),
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
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
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
