import 'package:flutter/material.dart';
import '../main.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favoritesList = [];
  bool _isLoading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = supabase.auth.currentUser?.id;
    if (userId != null) _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    if (userId == null) return;

    setState(() => _isLoading = true);

    try {
      final favs = await supabase
          .from('favorites')
          .select('item_id, table_name')
          .eq('user_id', userId as Object);

      final temp = await Future.wait(
        (favs as List).map((fav) async {
          final item = await supabase
              .from(fav['table_name'])
              .select('*')
              .eq('id', fav['item_id'])
              .maybeSingle();
          return item as Map<String, dynamic>?;
        }).whereType<Future<Map<String, dynamic>>>(),
      );

      setState(() => favoritesList = temp);
    } catch (e) {
      print('Error fetching favorites: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load favorites')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Favorites')),
        body: const Center(child: Text('Please log in to view your favorites.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoritesList.isEmpty
          ? const Center(child: Text('No favorites yet.'))
          : RefreshIndicator(
        onRefresh: _fetchFavorites,
        child: ListView.builder(
          itemCount: favoritesList.length,
          itemBuilder: (context, index) {
            final item = favoritesList[index];
            return ListTile(
              title: Text(item['title'] ?? ""),
              subtitle: Text(item['description'] ?? ""),
              trailing: item['link'] != null
                  ? const Icon(Icons.open_in_new)
                  : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailsScreen(
                      title: item['title'] ?? "",
                      subtitle: item['subtitle'],
                      description: item['description'],
                      link: item['link'],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
