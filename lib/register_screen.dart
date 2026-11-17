
import 'package:flutter/material.dart';

class RegisteredUsers {
  static final List<Map<String, String>> users = [];
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _identificadorController = TextEditingController();
  final _correoController = TextEditingController();
  final _areaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmarPasswordController = TextEditingController();

  String _selectedRole = 'Alumno';
  bool _mostrarPassword = false;
  bool _mostrarConfirmacion = false;

  final Color naranja = Colors.deepOrange;
  final Color fondo = const Color(0xFFFDFBF7);

  @override
  void dispose() {
    _nombreController.dispose();
    _identificadorController.dispose();
    _correoController.dispose();
    _areaController.dispose();
    _passwordController.dispose();
    _confirmarPasswordController.dispose();
    super.dispose();
  }

  void _registrarUsuario() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final correo = _correoController.text.trim().toLowerCase();

    final existe = RegisteredUsers.users.any(
      (usuario) => usuario['correo'] == correo,
    );

    if (existe) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este correo ya está registrado.'),
        ),
      );
      return;
    }

    RegisteredUsers.users.add({
      'nombre': _nombreController.text.trim(),
      'role': _selectedRole,
      'identificador': _identificadorController.text.trim(),
      'correo': correo,
      'area': _areaController.text.trim(),
      'password': _passwordController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registro completado correctamente.'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final esAlumno = _selectedRole == 'Alumno';

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: fondo,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text(
          'Crear cuenta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 48,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                const Center(
                  child: Text(
                    '¡Únete a nuestra biblioteca!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'Registra tus datos institucionales para continuar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Tipo de usuario',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _buildRoleOption('Alumno'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildRoleOption('Docente'),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                _buildLabel('Nombre completo'),

                _buildInput(
                  controller: _nombreController,
                  hint: 'Escribe tu nombre completo',
                  icon: Icons.person_outline_rounded,
                ),

                const SizedBox(height: 16),

                _buildLabel(
                  esAlumno ? 'Número de control' : 'Identificador institucional',
                ),

                _buildInput(
                  controller: _identificadorController,
                  hint: esAlumno
                      ? 'Ej. 22000000'
                      : 'Identificador institucional',
                  icon: Icons.badge_outlined,
                ),

                const SizedBox(height: 16),

                _buildLabel('Correo institucional'),

                _buildInput(
                  controller: _correoController,
                  hint: 'usuario@institucion.edu.mx',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  email: true,
                ),

                const SizedBox(height: 16),

                _buildLabel(esAlumno ? 'Carrera' : 'Departamento'),

                _buildInput(
                  controller: _areaController,
                  hint: esAlumno
                      ? 'Escribe tu carrera'
                      : 'Escribe tu departamento',
                  icon: Icons.school_outlined,
                ),

                const SizedBox(height: 16),

                _buildLabel('Contraseña'),

                _buildInput(
                  controller: _passwordController,
                  hint: 'Crea una contraseña',
                  icon: Icons.lock_outline_rounded,
                  password: true,
                  visible: _mostrarPassword,
                  onVisibilityChanged: () {
                    setState(() {
                      _mostrarPassword = !_mostrarPassword;
                    });
                  },
                ),

                const SizedBox(height: 16),

                _buildLabel('Confirmar contraseña'),

                _buildInput(
                  controller: _confirmarPasswordController,
                  hint: 'Repite tu contraseña',
                  icon: Icons.lock_reset_rounded,
                  password: true,
                  visible: _mostrarConfirmacion,
                  onVisibilityChanged: () {
                    setState(() {
                      _mostrarConfirmacion = !_mostrarConfirmacion;
                    });
                  },
                  confirmPassword: true,
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _registrarUsuario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: naranja,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Crear cuenta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      '¿Ya tienes una cuenta? Inicia sesión',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Center(
                  child: Text(
                    'Biblioteca ITSPR',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(String role) {
    final seleccionado = _selectedRole == role;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: seleccionado
              ? Colors.deepOrange.withOpacity(0.10)
              : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: seleccionado
                ? Colors.deepOrange
                : Colors.grey.shade300,
            width: seleccionado ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              role == 'Alumno'
                  ? Icons.school_rounded
                  : Icons.person_outline_rounded,
              color: seleccionado ? Colors.deepOrange : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              role,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: seleccionado ? Colors.deepOrange : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool email = false,
    bool password = false,
    bool visible = false,
    bool confirmPassword = false,
    VoidCallback? onVisibilityChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: password && !visible,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.deepOrange),
        suffixIcon: password
            ? IconButton(
                onPressed: onVisibilityChanged,
                icon: Icon(
                  visible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Colors.deepOrange,
            width: 1.5,
          ),
        ),
      ),
      validator: (value) {
        final texto = value?.trim() ?? '';

        if (texto.isEmpty) {
          return 'Este campo es obligatorio';
        }

        if (email) {
          if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
              .hasMatch(texto)) {
            return 'Escribe un correo válido';
          }
        }

        if (password && texto.length < 6) {
          return 'La contraseña debe tener al menos 6 caracteres';
        }

        if (confirmPassword &&
            texto != _passwordController.text) {
          return 'Las contraseñas no coinciden';
        }

        return null;
      },
    );
  }
}
