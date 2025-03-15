import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final Map<String, String> recipe;

  RecipeDetailPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title']!),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image or Placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image:
                    recipe.containsKey('image') && recipe['image']!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(recipe['image']!),
                            fit: BoxFit.cover,
                          )
                        : null,
              ),
              child: recipe.containsKey('image') && recipe['image']!.isNotEmpty
                  ? null
                  : Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
            ),

            // Recipe Details
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    recipe['title']!,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Time info
                  if (recipe['time'] != null && recipe['time']!.isNotEmpty)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time,
                              size: 16, color: Colors.green),
                          SizedBox(width: 4),
                          Text(
                            recipe['time']!,
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 24),

                  // Ingredients Section
                  if (recipe['ingredients'] != null &&
                      recipe['ingredients']!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bahan-bahan',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: recipe['ingredients']!.split(',').length,
                            itemBuilder: (context, index) {
                              final ingredient = recipe['ingredients']!
                                  .split(',')[index]
                                  .trim();
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check_circle,
                                        size: 16, color: Colors.green),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        ingredient,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 24),
                      ],
                    ),

                  // Cooking Instructions
                  Text(
                    'Langkah-langkah Memasak',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      recipe['description']!,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.edit_note, size: 28), // Ikon edit yang lebih jelas
        onPressed: () {
          // Implement edit functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fitur edit akan segera hadir'),
            ),
          );
        },
      ),
    );
  }
}
