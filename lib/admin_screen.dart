
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'login_screen.dart';
import 'library_data.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  // ==========================================
  // FORMULARIO PARA AGREGAR Y EDITAR LIBROS
  // ==========================================

  Future<void> mostrarFormulario(
    BuildContext context, {
    Map<String, String>? libro,
  }) async {
    final bool esEdicion = libro != null;

    final tituloController = TextEditingController(
      text: libro?['title'] ?? '',
    );

    final autorController = TextEditingController(
      text: libro?['author'] ?? '',
    );

    final descripcionController = TextEditingController(
      text: libro?['description'] ?? '',
    );

    String categoriaSeleccionada =
        libro?['category'] ?? LibraryData.categories.first;

    // Conserva la portada si estamos editando.
    String portadaSeleccionada = libro?['coverPath'] ?? '';

    final ImagePicker picker = ImagePicker();
    final formKey = GlobalKey<FormState>();

    // Seleccionar imagen desde cámara o galería.
    Future<void> seleccionarPortada(
      ImageSource source,
      StateSetter actualizar,
    ) async {
      try {
        final XFile? imagen = await picker.pickImage(
          source: source,
          imageQuality: 80,
          maxWidth: 1200,
        );

        if (imagen != null) {
          actualizar(() {
            portadaSeleccionada = imagen.path;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo seleccionar la imagen: $e'),
          ),
        );
      }
    }

    final resultado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFFDFBF7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Text(
                esEdicion ? 'Editar material' : 'Agregar material',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ==================================
                        // PORTADA DEL LIBRO
                        // ==================================

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Portada del material',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Container(
                          width: 150,
                          height: 190,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.deepOrange.shade200,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: portadaSeleccionada.isNotEmpty &&
                                  File(portadaSeleccionada).existsSync()
                              ? Image.file(
                                  File(portadaSeleccionada),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stack) {
                                    return _portadaVacia();
                                  },
                                )
                              : _portadaVacia(),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  seleccionarPortada(
                                    ImageSource.camera,
                                    setDialogState,
                                  );
                                },
                                icon: const Icon(Icons.camera_alt),
                                label: const Text('Cámara'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.deepOrange,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  seleccionarPortada(
                                    ImageSource.gallery,
                                    setDialogState,
                                  );
                                },
                                icon: const Icon(Icons.photo_library),
                                label: const Text('Galería'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.deepOrange,
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (portadaSeleccionada.isNotEmpty)
                          TextButton.icon(
                            onPressed: () {
                              setDialogState(() {
                                portadaSeleccionada = '';
                              });
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            label: const Text(
                              'Quitar portada',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),

                        const SizedBox(height: 18),

                        // ==================================
                        // TÍTULO
                        // ==================================

                        TextFormField(
                          controller: tituloController,
                          decoration: const InputDecoration(
                            labelText: 'Título del material',
                            prefixIcon: Icon(Icons.menu_book),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa el título';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        // ==================================
                        // AUTOR
                        // ==================================

                        TextFormField(
                          controller: autorController,
                          decoration: const InputDecoration(
                            labelText: 'Autor',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa el autor';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        // ==================================
                        // DESCRIPCIÓN
                        // ==================================

                        TextFormField(
                          controller: descripcionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Descripción',
                            prefixIcon: Icon(Icons.description_outlined),
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa una descripción';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        // ==================================
                        // CATEGORÍA
                        // ==================================

                        DropdownButtonFormField<String>(
                          value: categoriaSeleccionada,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Categoría',
                            prefixIcon: Icon(Icons.category_outlined),
                            border: OutlineInputBorder(),
                          ),
                          items: LibraryData.categories.map((categoria) {
                            return DropdownMenuItem<String>(
                              value: categoria,
                              child: Text(
                                categoria,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() {
                                categoriaSeleccionada = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(dialogContext, true);
                    }
                  },
                  child: Text(
                    esEdicion ? 'Guardar cambios' : 'Agregar',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    // ==========================================
    // GUARDAR MATERIAL
    // ==========================================

    if (resultado == true) {
      if (esEdicion) {
        LibraryData.updateBook(
          id: libro['id']!,
          title: tituloController.text.trim(),
          author: autorController.text.trim(),
          description: descripcionController.text.trim(),
          category: categoriaSeleccionada,
          coverPath: portadaSeleccionada,
        );
      } else {
        LibraryData.addBook(
          title: tituloController.text.trim(),
          author: autorController.text.trim(),
          description: descripcionController.text.trim(),
          category: categoriaSeleccionada,
          coverPath: portadaSeleccionada,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            esEdicion
                ? 'Material actualizado correctamente.'
                : 'Material agregado correctamente.',
          ),
        ),
      );
    }

    tituloController.dispose();
    autorController.dispose();
    descripcionController.dispose();
  }

  // ==========================================
  // PORTADA VACÍA
  // ==========================================

  Widget _portadaVacia() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu_book,
          size: 55,
          color: Colors.deepOrange,
        ),
        SizedBox(height: 8),
        Text(
          'Sin portada',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  // ==========================================
  // CONFIRMAR ELIMINACIÓN
  // ==========================================

  Future<void> confirmarEliminacion(
    BuildContext context,
    Map<String, String> libro,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Eliminar material'),
          content: Text(
            '¿Deseas eliminar "${libro['title']}" del catálogo?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      LibraryData.deleteBook(libro['id']!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Material eliminado correctamente.'),
        ),
      );
    }
  }

  // ==========================================
  // SECCIONES PENDIENTES
  // ==========================================

  void _mostrarPendiente(BuildContext context, String seccion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$seccion: sección pendiente de desarrollar.',
        ),
      ),
    );
  }

  // ==========================================
  // TARJETAS DEL PANEL
  // ==========================================

  Widget _opcion({
    required IconData icono,
    required String titulo,
    required String descripcion,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFFFE0B2),
          child: Icon(
            icono,
            color: Colors.deepOrange,
          ),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(descripcion),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  // ==========================================
  // PANEL PRINCIPAL
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
        title: const Text(
          'Administración ITSPR',
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(
              Icons.logout,
              color: Colors.deepOrange,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¡Bienvenido, Administrador!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Panel de control de la Biblioteca ITSPR',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 25),

            // CONTADOR DE MATERIALES
            ValueListenableBuilder<int>(
              valueListenable: LibraryData.booksNotifier,
              builder: (context, version, child) {
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: Color(0xFFFFE0B2),
                          child: Icon(
                            Icons.library_books,
                            color: Colors.deepOrange,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Materiales registrados',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                '${LibraryData.books.length}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            const Text(
              'Administración de la biblioteca',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            _opcion(
              icono: Icons.menu_book,
              titulo: 'Gestión de libros',
              descripcion: 'Agregar, editar y eliminar materiales',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminBooksScreen(
                      admin: this,
                    ),
                  ),
                );
              },
            ),

            _opcion(
              icono: Icons.people,
              titulo: 'Gestión de usuarios',
              descripcion: 'Consultar alumnos y docentes',
              onTap: () {
                _mostrarPendiente(context, 'Gestión de usuarios');
              },
            ),

            _opcion(
              icono: Icons.assignment,
              titulo: 'Solicitudes y préstamos',
              descripcion: 'Administrar solicitudes de materiales',
              onTap: () {
                _mostrarPendiente(
                  context,
                  'Solicitudes y préstamos',
                );
              },
            ),

            _opcion(
              icono: Icons.notifications,
              titulo: 'Avisos y comunicados',
              descripcion: 'Publicar avisos para los usuarios',
              onTap: () {
                _mostrarPendiente(context, 'Avisos y comunicados');
              },
            ),

            _opcion(
              icono: Icons.bar_chart,
              titulo: 'Reportes',
              descripcion: 'Consultar información de la biblioteca',
              onTap: () {
                _mostrarPendiente(context, 'Reportes');
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// PANTALLA DE GESTIÓN DE LIBROS
// ==========================================

class AdminBooksScreen extends StatelessWidget {
  final AdminScreen admin;

  const AdminBooksScreen({
    super.key,
    required this.admin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
        title: const Text(
          'Gestión de libros',
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Agregar libro'),
        onPressed: () {
          admin.mostrarFormulario(context);
        },
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: LibraryData.booksNotifier,
        builder: (context, version, child) {
          final libros = LibraryData.books;

          if (libros.isEmpty) {
            return const Center(
              child: Text('No hay libros registrados.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: libros.length,
            itemBuilder: (context, index) {
              final libro = libros[index];
              final portada = libro['coverPath'] ?? '';

              return Card(
                color: Colors.white,
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // PORTADA EN LA TARJETA
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 75,
                              height: 105,
                              color: Colors.orange.shade50,
                              child: portada.isNotEmpty &&
                                      File(portada).existsSync()
                                  ? Image.file(
                                      File(portada),
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stack,
                                      ) {
                                        return const Icon(
                                          Icons.menu_book,
                                          color: Colors.deepOrange,
                                          size: 35,
                                        );
                                      },
                                    )
                                  : const Icon(
                                      Icons.menu_book,
                                      color: Colors.deepOrange,
                                      size: 35,
                                    ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  libro['title'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Autor: ${libro['author'] ?? ''}',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Categoría: ${libro['category'] ?? ''}',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Divider(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              admin.mostrarFormulario(
                                context,
                                libro: libro,
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 18,
                            ),
                            label: const Text('Editar'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.deepOrange,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              admin.confirmarEliminacion(
                                context,
                                libro,
                              );
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 18,
                            ),
                            label: const Text('Eliminar'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
