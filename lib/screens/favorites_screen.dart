import 'package:flutter/material.dart';
import '../main.dart';
import 'detail_screen.dart';
import 'package:collection/collection.dart';

class FavoritesScreen extends StatelessWidget {
  final Map<String, dynamic> favoriteStates;

  const FavoritesScreen({Key? key, required this.favoriteStates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            final favoriteItems = allData.where((item) => favoriteStates['${item['table_name']}-${item['id']}']?['isFavorite'] == true).toList();

            if (favoriteItems.isEmpty) {
              return const Center(child: Text('No favorites yet.'));
            }

            return ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item = favoriteItems[index];
                final key = '${item['table_name']}-${item['id']}';
                final color = favoriteStates[key]?['color'] as Color? ?? Colors.white;

                return Card(
                  color: color, // Apply stored color
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(item['title'] ?? item['name'] ?? "No Title", style: TextStyle(color: Colors.black),),
                    subtitle: Text(item['description'] ?? item['address'] ?? "No Description", style: TextStyle(color: Colors.grey[700]),),
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
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchData(String tableName) async {
    final response = await supabase.from(tableName).select('*').withConverter((data) {
      return (data as List).cast<Map<String, dynamic>>().map((item) {
        return item..addAll({'table_name': tableName});
      }).toList();
    });
    return response;
  }
}