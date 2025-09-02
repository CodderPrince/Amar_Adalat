// home_screen.dart
import 'package:flutter/material.dart';
import 'package:ptib1/style/myAppBar.dart';
import 'dart:math';
import 'rights_screen.dart';
import 'legal_aid_directory_screen.dart';
import 'legal_guides_screen.dart';
import 'report_screen.dart';
import 'favorites_screen.dart';
import 'admin_view_screen.dart';
import '../widgets/card_item.dart';
import 'auth_screen.dart';
import '../services/favorites_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Store favorite status and color
  Map<String, dynamic> favoriteStates = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialFavoriteStates();
  }

  Future<void> _loadInitialFavoriteStates() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Load all favorites for current user and put in memory to access syncrounously.
      final favorites = await FavoritesService().fetchFavorites();
      for (var fav in favorites) {
        favoriteStates['${fav['table_name']}-${fav['item_id']}'] = {
          'isFavorite': true,
          'color': _getRandomLightColor(),
        };
      }
    } catch (error) {
      print('Error loading initial favorites: $error');
      // Optionally show an error message to the user
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Callback function to update the favorite state from SupabaseListScreen
  void updateFavoriteState(String tableName, String itemId, bool isFavorite) {
    final key = '$tableName-$itemId';
    setState(() {
      if (isFavorite) {
        favoriteStates[key] = {'isFavorite': true, 'color': _getRandomLightColor()};
      } else {
        favoriteStates.remove(key);
      }
    });
  }

  Color _getRandomLightColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      200 + random.nextInt(56),
      200 + random.nextInt(56),
      200 + random.nextInt(56),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Amar Adalat'), centerTitle: true),
      appBar: MyAppBar18(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            HomeCard(
              title: 'Fundamental Rights',
              icon: Icons.arrow_circle_right,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RightsScreen(
                        tableName: 'rights',
                        updateFavoriteState: updateFavoriteState,
                        favoriteStates: favoriteStates)),
              ),
              backgroundColor: Colors.blue[700]!, // Dark blue color
            ),
            HomeCard(
              title: 'Legal Aid Directory',
              icon: Icons.people,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LegalAidDirectoryScreen(
                        tableName: 'legal_aids',
                        updateFavoriteState: updateFavoriteState,
                        favoriteStates: favoriteStates)),
              ),
              backgroundColor: Colors.green[700]!, // Dark green color
            ),
            HomeCard(
              title: 'Legal Guides',
              icon: Icons.menu_book,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LegalGuidesScreen(
                        tableName: 'legal_guides',
                        updateFavoriteState: updateFavoriteState,
                        favoriteStates: favoriteStates)),
              ),
              backgroundColor: Colors.orange[700]!, // Dark orange color
            ),
            HomeCard(
              title: 'Report Issues',
              icon: Icons.report,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportScreen()),
              ),
              backgroundColor: Colors.red[700]!, // Dark red color
            ),
            HomeCard(
              title: 'Favorites',
              icon: Icons.favorite,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FavoritesScreen(favoriteStates: favoriteStates)),
              ),
              backgroundColor: Colors.purple[700]!, // Dark purple color
            ),
            HomeCard(
              title: 'Admin View',
              icon: Icons.settings,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminViewScreen())),
              backgroundColor: Colors.grey[700]!, // Dark grey color
            ),
            HomeCard(
                title: 'Auth',
                icon: Icons.account_circle, // Choose an appropriate icon
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                ),
                backgroundColor: Colors.brown[700]!,
                textColor: Colors.white
            ),
          ],
        ),
      ),
    );
  }
}