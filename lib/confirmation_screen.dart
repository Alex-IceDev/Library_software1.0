
import 'package:flutter/material.dart';
import 'library_data.dart';

class ConfirmationScreen extends StatefulWidget {
  final String title;
  final String author;
  final String tipoOperacion;

  const ConfirmationScreen({
    super.key,
    required this.title,
    required this.author,
    required this.tipoOperacion,
  });

  @override
  State<ConfirmationScreen> createState() =>
      _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  void initState() {
    super.initState();

    // Registrar la solicitud una sola vez al abrir esta pantalla.
    LibraryData.addRequest(
      title: widget.title,
      author: widget.author,
      tipoOperacion: widget.tipoOperacion,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool esReserva = widget.tipoOperacion == 'Reservar';

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text('Confirmación'),
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 90,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  esReserva
                      ? '¡Reserva realizada!'
                      : '¡Solicitud realizada!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  esReserva
                      ? 'Tu solicitud de reserva se ha registrado correctamente.'
                      : 'Tu solicitud para ordenar este material se ha registrado correctamente.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 28),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detalles de tu solicitud',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 18),

                      _dato(
                        Icons.menu_book_rounded,
                        'Material',
                        widget.title,
                      ),

                      const SizedBox(height: 14),

                      _dato(
                        Icons.person_outline_rounded,
                        'Autor',
                        widget.author,
                      ),

                      const SizedBox(height: 14),

                      _dato(
                        Icons.assignment_turned_in_outlined,
                        'Tipo de solicitud',
                        widget.tipoOperacion,
                      ),

                      const SizedBox(height: 14),

                      _dato(
                        Icons.pending_actions_rounded,
                        'Estado',
                        'Pendiente',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        (route) => route.isFirst,
                      );
                    },
                    child: const Text(
                      'Volver al inicio',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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

  Widget _dato(
    IconData icono,
    String etiqueta,
    String valor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icono,
          color: Colors.deepOrange,
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                etiqueta,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                valor,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
