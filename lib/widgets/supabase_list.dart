import 'package:flutter/material.dart';
import '../main.dart';
import 'package:url_launcher/url_launcher.dart';

class SupabaseListScreen extends StatefulWidget {
  final String tableName;
  final String titleField;
  final String? subtitleField;
  final String appBarTitle;

  const SupabaseListScreen({
    required this.tableName,
    required this.titleField,
    this.subtitleField,
    required this.appBarTitle,
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
    item[widget.titleField]
        ?.toString()
        .toLowerCase()
        .contains(searchQuery.toLowerCase()) ??
        false)
        .toList();
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
                  return ListTile(
                    title: Text(item[widget.titleField] ?? ""),
                    subtitle: widget.subtitleField != null
                        ? Text(item[widget.subtitleField!] ?? "")
                        : null,
                    trailing: item['link'] != null
                        ? const Icon(Icons.open_in_new)
                        : null,
                    onTap: () {
                      if (item['link'] != null) {
                        final uri = Uri.parse(item['link']);
                        launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
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
