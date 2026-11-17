
import 'package:flutter/material.dart';

class LibraryData {
  // ==========================================
  // SOLICITUDES DE LOS USUARIOS
  // ==========================================

  static final List<Map<String, String>> requests = [];

  static void addRequest({
    required String title,
    required String author,
    required String tipoOperacion,
  }) {
    requests.insert(0, {
      'title': title,
      'author': author,
      'tipoOperacion': tipoOperacion,
      'status': 'Pendiente',
    });
  }

  // ==========================================
  // CATEGORÍAS DE LA BIBLIOTECA
  // ==========================================

  static const List<String> categories = [
    'Revistas',
    'Memorias de Residencia',
    'Obras',
    'Ciencias Básicas',
    'Ciencias Sociales y Humanidades',
    'Ingeniería Aplicada',
    'Ciencias de la Ingeniería',
  ];

  // ==========================================
  // LISTA COMPARTIDA DE LIBROS
  // ==========================================

  static final ValueNotifier<int> booksNotifier =
      ValueNotifier<int>(0);

  static final List<Map<String, String>> books = [
    {
      'id': '1',
      'title': 'Revista de Ciencia y Tecnología',
      'author': 'Instituto Tecnológico',
      'description': 'Revista con artículos científicos y tecnológicos.',
      'category': 'Revistas',
      'coverPath': '',
    },
    {
      'id': '2',
      'title': 'Innovación Tecnológica',
      'author': 'Varios autores',
      'description': 'Publicación sobre avances e innovación.',
      'category': 'Revistas',
      'coverPath': '',
    },
    {
      'id': '3',
      'title': 'Sistema de Gestión Empresarial',
      'author': 'Estudiante ITSPR',
      'description': 'Proyecto de residencia profesional.',
      'category': 'Memorias de Residencia',
      'coverPath': '',
    },
    {
      'id': '4',
      'title': 'Desarrollo de Aplicación Web',
      'author': 'Estudiante ITSPR',
      'description': 'Memoria de desarrollo de software.',
      'category': 'Memorias de Residencia',
      'coverPath': '',
    },
    {
      'id': '5',
      'title': 'Introducción a la Literatura',
      'author': 'Autor de ejemplo',
      'description': 'Obra de consulta general.',
      'category': 'Obras',
      'coverPath': '',
    },
    {
      'id': '6',
      'title': 'Colección de Obras Clásicas',
      'author': 'Varios autores',
      'description': 'Colección de obras literarias.',
      'category': 'Obras',
      'coverPath': '',
    },
    {
      'id': '7',
      'title': 'Cálculo Diferencial',
      'author': 'Autor de ejemplo',
      'description': 'Material de apoyo para matemáticas.',
      'category': 'Ciencias Básicas',
      'coverPath': '',
    },
    {
      'id': '8',
      'title': 'Física General',
      'author': 'Autor de ejemplo',
      'description': 'Conceptos fundamentales de física.',
      'category': 'Ciencias Básicas',
      'coverPath': '',
    },
    {
      'id': '9',
      'title': 'Ética Profesional',
      'author': 'Autor de ejemplo',
      'description': 'Estudio de valores y ética profesional.',
      'category': 'Ciencias Sociales y Humanidades',
      'coverPath': '',
    },
    {
      'id': '10',
      'title': 'Comunicación Humana',
      'author': 'Autor de ejemplo',
      'description': 'Material sobre comunicación y sociedad.',
      'category': 'Ciencias Sociales y Humanidades',
      'coverPath': '',
    },
    {
      'id': '11',
      'title': 'Automatización Industrial',
      'author': 'Autor de ejemplo',
      'description': 'Aplicaciones de automatización.',
      'category': 'Ingeniería Aplicada',
      'coverPath': '',
    },
    {
      'id': '12',
      'title': 'Diseño de Sistemas',
      'author': 'Autor de ejemplo',
      'description': 'Fundamentos de diseño aplicado.',
      'category': 'Ingeniería Aplicada',
      'coverPath': '',
    },
    {
      'id': '13',
      'title': 'Fundamentos de Ingeniería',
      'author': 'Autor de ejemplo',
      'description': 'Conceptos generales de ingeniería.',
      'category': 'Ciencias de la Ingeniería',
      'coverPath': '',
    },
    {
      'id': '14',
      'title': 'Análisis de Circuitos',
      'author': 'Autor de ejemplo',
      'description': 'Estudio de circuitos eléctricos.',
      'category': 'Ciencias de la Ingeniería',
      'coverPath': '',
    },
  ];

  // ==========================================
  // AGREGAR LIBRO
  // ==========================================

  static void addBook({
    required String title,
    required String author,
    required String description,
    required String category,
    String coverPath = '',
  }) {
    final nuevoId = DateTime.now()
        .microsecondsSinceEpoch
        .toString();

    books.add({
      'id': nuevoId,
      'title': title,
      'author': author,
      'description': description,
      'category': category,
      'coverPath': coverPath,
    });

    booksNotifier.value++;
  }

  // ==========================================
  // EDITAR LIBRO
  // ==========================================

  static void updateBook({
    required String id,
    required String title,
    required String author,
    required String description,
    required String category,
    String? coverPath,
  }) {
    final index = books.indexWhere(
      (book) => book['id'] == id,
    );

    if (index == -1) return;

    final portadaActual = books[index]['coverPath'] ?? '';

    books[index] = {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'category': category,
      'coverPath': coverPath ?? portadaActual,
    };

    booksNotifier.value++;
  }

  // ==========================================
  // ELIMINAR LIBRO
  // ==========================================

  static void deleteBook(String id) {
    books.removeWhere((book) => book['id'] == id);
    booksNotifier.value++;
  }

  // ==========================================
  // OBTENER LIBROS POR CATEGORÍA
  // ==========================================

  static List<Map<String, String>> getBooksByCategory(
    String category,
  ) {
    return books
        .where((book) => book['category'] == category)
        .toList();
  }
}
