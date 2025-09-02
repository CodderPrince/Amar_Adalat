import 'package:flutter/material.dart';
import '../main.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/detail_screen.dart'; // Import DetailScreen
import 'dart:math';

class SupabaseListScreen extends StatefulWidget {
  final String tableName;
  final String titleField;
  final String? subtitleField;
  final String appBarTitle;
  final Function(String, String, bool)? updateFavoriteState;
  final Map<String, dynamic>? favoriteStates;

  const SupabaseListScreen({
    required this.tableName,
    required this.titleField,
    this.subtitleField,
    required this.appBarTitle,
    this.updateFavoriteState,
    this.favoriteStates,
    super.key,
  });

  @override
  _SupabaseListScreenState createState() => _SupabaseListScreenState();
}

class _SupabaseListScreenState extends State<SupabaseListScreen> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filteredData = [];
  bool _isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _isLoading = true);
    try {
      final response = await supabase.from(widget.tableName).select('*');
      data = (response as List).cast<Map<String, dynamic>>();

      // Initialize 'isFavorited' based on HomeScreen's state, or to false if not found.
      for (var item in data) {
        final key = '${widget.tableName}-${item['id']}';
        item['isFavorited'] = widget.favoriteStates?[key]?['isFavorite'] ?? false;
      }
      _filterData();
    } catch (e) {
      debugPrint("Error fetching ${widget.tableName}: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load ${widget.appBarTitle}')),
      );
    }
    setState(() => _isLoading = false);
  }

  void _filterData() {
    filteredData = data
        .where((item) =>
        (item[widget.titleField]?.toString().toLowerCase() ?? '')
            .contains(searchQuery.toLowerCase()))
        .toList();
  }

  void _launchLink(String? link) async {
    if (link == null || link.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No link available')));
      return;
    }
    final uri = Uri.parse(link);
    try {
      if (!await canLaunchUrl(uri)) throw 'Cannot launch $link';
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not open link')));
    }
  }

  void _toggleFavorite(Map<String, dynamic> item) {
    final itemId = item['id'].toString();
    final isCurrentlyFavorite = item['isFavorited'] as bool? ?? false; // Safely cast to bool
    final key = '${widget.tableName}-${itemId}';

    // Toggle the local state.
    setState(() {
      item['isFavorited'] = !isCurrentlyFavorite;
    });

    // Update the HomeScreen's state using the callback.
    widget.updateFavoriteState?.call(widget.tableName, itemId, !isCurrentlyFavorite);
  }

  Color _getRandomLightColor() {
    final Random random = Random();
    // Generate a color with high brightness (close to white)
    return Color.fromARGB(
      255,
      200 + random.nextInt(56), // Red: 200-255
      200 + random.nextInt(56), // Green: 200-255
      200 + random.nextInt(56), // Blue: 200-255
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.appBarTitle)),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search ${widget.appBarTitle}',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                  _filterData();
                });
              },
            ),
          ),
          // LIST
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredData.isEmpty
                ? Center(child: Text('No ${widget.appBarTitle} found.'))
                : RefreshIndicator(
              onRefresh: _fetch,
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, i) {
                  final item = filteredData[i];
                  final key = '${widget.tableName}-${item['id']}';
                  final color = widget.favoriteStates?[key]?['color'] as Color? ?? _getRandomLightColor();
                  return Card( // Wrap ListTile in a Card
                    color: color,
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ListTile(
                      title: Text(item[widget.titleField] ?? 'No title', style: TextStyle(color: Colors.black),),
                      subtitle: widget.subtitleField != null
                          ? Text(
                        item[widget.subtitleField!] ??
                            'No description',  style: TextStyle(color: Colors.grey[700]),
                      )
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              item['isFavorited'] == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: item['isFavorited'] == true ? Colors.red : null,
                            ),
                            onPressed: () => _toggleFavorite(item),
                          ),
                          if (item['link'] != null &&
                              (item['link'] as String).isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.open_in_new),
                              onPressed: () => _launchLink(item['link']),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}