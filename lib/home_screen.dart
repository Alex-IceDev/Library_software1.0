
import 'package:flutter/material.dart';

import 'catalog_screen.dart';
import 'library_data.dart';
import 'notifications_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String role;
  final String institutionalId;
  final String fullName;
  final String area;

  const HomeScreen({
    super.key,
    required this.role,
    required this.institutionalId,
    required this.fullName,
    required this.area,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _irANotificaciones() {
    setState(() {
      _selectedIndex = 4;
    });
  }

  Widget _buildInicio() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            '¡Hola, ${widget.fullName}!',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bienvenido a la Biblioteca ITSPR',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 25),

          // Acceso a notificaciones
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFFE0B2),
                child: Icon(
                  Icons.notifications,
                  color: Colors.deepOrange,
                ),
              ),
              title: const Text(
                'Avisos y notificaciones',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Consulta tus avisos de la biblioteca',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _irANotificaciones,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Explora nuestra biblioteca',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFFE0B2),
                child: Icon(
                  Icons.menu_book,
                  color: Colors.deepOrange,
                ),
              ),
              title: const Text(
                'Catálogo de materiales',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Consulta los libros y materiales disponibles',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
          ),

          const SizedBox(height: 12),

          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFFE0B2),
                child: Icon(
                  Icons.bookmark,
                  color: Colors.deepOrange,
                ),
              ),
              title: const Text(
                'Mi biblioteca',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Consulta tus solicitudes y reservas',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiblioteca() {
    final solicitudes = LibraryData.requests;

    return solicitudes.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books_outlined,
                    size: 65,
                    color: Colors.deepOrange,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Aún no tienes solicitudes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Cuando solicites un material aparecerá aquí.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: solicitudes.length,
            itemBuilder: (context, index) {
              final solicitud = solicitudes[index];

              return Card(
                color: Colors.white,
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFE0B2),
                    child: Icon(
                      Icons.menu_book,
                      color: Colors.deepOrange,
                    ),
                  ),
                  title: Text(
                    solicitud.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text('Solicitud registrada'),
                ),
              );
            },
          );
  }

  Widget _buildPerfil() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFFFFE0B2),
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            widget.fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),

          _datoPerfil(
            Icons.badge,
            'Tipo de usuario',
            widget.role,
          ),
          _datoPerfil(
            Icons.credit_card,
            'Identificador institucional',
            widget.institutionalId,
          ),
          _datoPerfil(
            Icons.school,
            'Carrera / Departamento',
            widget.area,
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _datoPerfil(
    IconData icono,
    String titulo,
    String valor,
  ) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icono, color: Colors.deepOrange),
        title: Text(
          titulo,
          style: const TextStyle(fontSize: 13),
        ),
        subtitle: Text(
          valor,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lista de pantallas: no necesita GlobalKey.
    final List<Widget> pages = [
      _buildInicio(),
      CatalogScreen(),
      _buildBiblioteca(),
      _buildPerfil(),
      const NotificationsScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
        title: const Text(
          'Biblioteca ITSPR',
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.deepOrange,
            ),
            tooltip: 'Notificaciones',
            onPressed: _irANotificaciones,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            activeIcon: Icon(Icons.library_books),
            label: 'Mi biblioteca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            activeIcon: Icon(Icons.notifications),
            label: 'Avisos',
          ),
        ],
      ),
    );
  }
}
