
import 'package:flutter/material.dart';
import 'book_detail_screen.dart';
import 'library_data.dart';

class BookListScreen extends StatelessWidget {
  final String categoryName;

  const BookListScreen({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: LibraryData.booksNotifier,
          builder: (context, version, child) {
            final categoryBooks =
                LibraryData.getBooksByCategory(categoryName);

            if (categoryBooks.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: 65,
                      color: Colors.deepOrange,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No hay materiales disponibles.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categoryBooks.length,
              itemBuilder: (context, index) {
                final book = categoryBooks[index];

                return Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.deepOrange,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      book['title'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Autor: ${book['author'] ?? ''}',
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.deepOrange,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailScreen(
                            title: book['title'] ?? '',
                            author: book['author'] ?? '',
                            description: book['description'] ?? '',
                          ),
                        ),
                      );
                    },
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
