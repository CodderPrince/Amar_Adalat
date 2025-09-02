// favorites_screen.dart
import 'package:flutter/material.dart';
import '../main.dart';
import 'detail_screen.dart';
import 'package:collection/collection.dart'; // Import the collection package

class FavoritesScreen extends StatelessWidget {
  final Map<String, bool> favoriteStates;

  const FavoritesScreen({Key? key, required this.favoriteStates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Combine all data sources (rights, legal_aids, legal_guides).
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: FutureBuilder<List<List<Map<String, dynamic>>>>(
        future: Future.wait([
          fetchData('rights'),
          fetchData('legal_aids'),
          fetchData('legal_guides'),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading favorites: ${snapshot.error}'));
          } else {
            // Flatten the list of lists into a single list
            final allData = snapshot.data!.flattened.toList();
            // Filter items based on the favoriteStates
            final favoriteItems = allData.where((item) => favoriteStates['${item['table_name']}-${item['id']}'] == true).toList();

            if (favoriteItems.isEmpty) {
              return const Center(child: Text('No favorites yet.'));
            }

            return ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item = favoriteItems[index];
                return ListTile(
                  title: Text(item['title'] ?? item['name'] ?? "No Title"), // Handle different title fields
                  subtitle: Text(item['description'] ?? item['address'] ?? "No Description"), // Handle different description fields
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsScreen(
                          title: item['title'] ?? item['name'] ?? "",
                          subtitle: item['subtitle'],
                          description: item['description'] ?? item['address'],
                          link: item['link'],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  // Helper function to fetch data from a table
  Future<List<Map<String, dynamic>>> fetchData(String tableName) async {
    final response = await supabase.from(tableName).select('*').withConverter((data) {
      return (data as List).cast<Map<String, dynamic>>().map((item) {
        return item..addAll({'table_name': tableName});
      }).toList();
    });
    return response;
  }
}