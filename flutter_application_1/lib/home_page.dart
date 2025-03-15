import 'package:flutter/material.dart';
import 'add_recipe_page.dart';
import 'recipe_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> recipes = [];

  void _addRecipe(Map<String, String> recipe) {
    if (!recipes.any((r) => r['title'] == recipe['title'])) {
      setState(() {
        recipes.add(recipe);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resep sudah ada!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catatan Resep',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: RecipeSearch(recipes));
            },
          ),
        ],
      ),
      body: recipes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu,
                      size: 100, color: Colors.green[300]),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada resep',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tekan tombol + untuk menambahkan resep',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  RecipeDetailPage(recipe: recipes[index]),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                        ),
                      );
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.withOpacity(0.2),
                        child: Icon(Icons.restaurant, color: Colors.green),
                      ),
                      title: Text(
                        recipes[index]['title']!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6),
                          Text(
                            recipes[index]['description']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          SizedBox(height: 6),
                          if (recipes[index]['time'] != null &&
                              recipes[index]['time']!.isNotEmpty)
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 14, color: Colors.grey[600]),
                                SizedBox(width: 4),
                                Text(
                                  recipes[index]['time']!,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.green,
        tooltip: 'Tambah Resep',
        onPressed: () async {
          final newRecipe = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecipePage()),
          );
          if (newRecipe != null) {
            _addRecipe(newRecipe);
          }
        },
      ),
    );
  }
}

class RecipeSearch extends SearchDelegate<String> {
  final List<Map<String, String>> recipes;

  RecipeSearch(this.recipes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back), onPressed: () => close(context, ''));
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = recipes
        .where((recipe) =>
            recipe['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView(
      children: results
          .map((r) => ListTile(
                title: Text(r['title']!),
                subtitle: Text(r['description']!),
                onTap: () {
                  close(context, '');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(recipe: r)),
                  );
                },
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = recipes
        .where((recipe) =>
            recipe['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView(
      children: suggestions
          .map((r) => ListTile(
                title: Text(r['title']!),
                subtitle: Text(r['description']!),
                onTap: () {
                  query = r['title']!;
                  showResults(context);
                },
              ))
          .toList(),
    );
  }
}
