
import 'package:flutter/material.dart';
import 'book_list_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'name': 'Revistas',
      'icon': Icons.newspaper_rounded,
    },
    {
      'name': 'Memorias de Residencia',
      'icon': Icons.assignment_turned_in_rounded,
    },
    {
      'name': 'Obras',
      'icon': Icons.auto_stories_rounded,
    },
    {
      'name': 'Ciencias Básicas',
      'icon': Icons.functions_rounded,
    },
    {
      'name': 'Ciencias Sociales y Humanidades',
      'icon': Icons.groups_rounded,
    },
    {
      'name': 'Ingeniería Aplicada',
      'icon': Icons.engineering_rounded,
    },
    {
      'name': 'Ciencias de la Ingeniería',
      'icon': Icons.architecture_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),

      appBar: AppBar(
        title: const Text(
          'Categorías del Acervo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: GridView.builder(
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.0,
            ),

            itemCount: categories.length,

            itemBuilder: (context, index) {
              final category = categories[index];

              final String categoryName =
                  category['name'] as String;

              final IconData categoryIcon =
                  category['icon'] as IconData;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookListScreen(
                        categoryName: categoryName,
                      ),
                    ),
                  );
                },

                child: Container(
                  padding: const EdgeInsets.all(14.0),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),

                        child: Icon(
                          categoryIcon,
                          size: 32,
                          color: Colors.orange,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        categoryName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
