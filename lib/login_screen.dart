
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'recover_password_screen.dart';
import 'admin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _selectedRole = 'Alumno';
  bool _mostrarPassword = false;

  // Credenciales predeterminadas del administrador.
  static const String _adminUser = 'admin';
  static const String _adminPassword = 'Admin123*';

  final List<String> _roles = [
    'Alumno',
    'Docente',
    'Administrador',
  ];

  final TextEditingController _identificadorController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  @override
  void dispose() {
    _identificadorController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  void _ingresar() {
    final identificador =
        _identificadorController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (identificador.isEmpty || password.isEmpty) {
      _mostrarMensaje('Completa todos los campos.');
      return;
    }

    // ACCESO DEL ADMINISTRADOR
    if (_selectedRole == 'Administrador') {
      if (identificador == _adminUser &&
          password == _adminPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminScreen(),
          ),
        );
      } else {
        _mostrarMensaje(
          'Usuario o contraseña de administrador incorrectos.',
        );
      }
      return;
    }

    // ACCESO DE ALUMNOS Y DOCENTES
    final usuarioEncontrado = RegisteredUsers.users.where((usuario) {
      final identificadorRegistrado =
          _selectedRole == 'Alumno'
              ? usuario['identificador']?.toLowerCase()
              : usuario['correo']?.toLowerCase();

      return usuario['role'] == _selectedRole &&
          identificadorRegistrado == identificador &&
          usuario['password'] == password;
    });

    if (usuarioEncontrado.isEmpty) {
      _mostrarMensaje(
        'No encontramos una cuenta con esos datos. '
        'Verifica tus credenciales o regístrate.',
      );
      return;
    }

    final usuario = usuarioEncontrado.first;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          role: usuario['role']!,
          institutionalId: usuario['role'] == 'Alumno'
              ? usuario['identificador']!
              : usuario['correo']!,
          fullName: usuario['nombre']!,
          area: usuario['area']!,
        ),
      ),
    );
  }

  void _abrirRegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  void _abrirRecuperacion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RecoverPasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esAlumno = _selectedRole == 'Alumno';
    final esAdministrador = _selectedRole == 'Administrador';

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      esAdministrador
                          ? Icons.admin_panel_settings
                          : Icons.school_rounded,
                      size: 60,
                      color: Colors.deepOrange,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Biblioteca ITSPR',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    esAdministrador
                        ? 'Acceso al panel administrativo'
                        : 'Inicia sesión institucional',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // SELECCIÓN DE ROL
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedRole,
                        isExpanded: true,
                        items: _roles.map((role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text('Rol: $role'),
                          );
                        }).toList(),
                        onChanged: (newRole) {
                          if (newRole != null) {
                            setState(() {
                              _selectedRole = newRole;
                              _identificadorController.clear();
                              _passwordController.clear();
                              _mostrarPassword = false;
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // IDENTIFICADOR
                  TextField(
                    controller: _identificadorController,
                    keyboardType: esAlumno || esAdministrador
                        ? TextInputType.text
                        : TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: esAlumno
                          ? 'Número de control'
                          : esAdministrador
                              ? 'Usuario administrador'
                              : 'Correo institucional',
                      prefixIcon: const Icon(
                        Icons.badge_outlined,
                        color: Colors.deepOrange,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // CONTRASEÑA
                  TextField(
                    controller: _passwordController,
                    obscureText: !_mostrarPassword,
                    onSubmitted: (_) => _ingresar(),
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.deepOrange,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _mostrarPassword = !_mostrarPassword;
                          });
                        },
                        icon: Icon(
                          _mostrarPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  // RECUPERACIÓN PARA ALUMNOS Y DOCENTES
                  if (!esAdministrador) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _abrirRecuperacion,
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                  ],

                  const SizedBox(height: 10),

                  // BOTÓN INGRESAR
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: _ingresar,
                      child: Text(
                        'Ingresar como $_selectedRole',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // REGISTRO SOLO PARA ALUMNOS Y DOCENTES
                  if (!esAdministrador) ...[
                    const SizedBox(height: 18),
                    const Divider(),
                    const SizedBox(height: 12),

                    const Text(
                      '¿Todavía no tienes una cuenta?',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _abrirRegistro,
                        icon: const Icon(
                          Icons.person_add_alt_1_rounded,
                        ),
                        label: const Text(
                          'Crear cuenta',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.deepOrange,
                          side: const BorderSide(
                            color: Colors.deepOrange,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  Text(
                    esAdministrador
                        ? 'Acceso exclusivo para administración'
                        : 'Acceso exclusivo para integrantes del ITSPR',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black38,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

