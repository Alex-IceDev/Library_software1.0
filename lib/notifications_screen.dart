
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {

  final Color backgroundColor = const Color(0xFFFDFBF7);
  final Color primaryColor = Colors.deepOrange;

  String _filtroSeleccionado = 'Todas';

  final List<Map<String, dynamic>> _notificaciones = [
    {
      'titulo': 'Reserva confirmada',
      'mensaje':
          'Tu solicitud del libro "Fundamentos de programación" ha sido registrada correctamente.',
      'fecha': 'Hoy, 09:30',
      'tipo': 'Reserva',
      'icono': Icons.bookmark_added_outlined,
      'leida': false,
    },
    {
      'titulo': 'Recordatorio de devolución',
      'mensaje':
          'Recuerda que tienes un material pendiente de devolución. Consulta tu biblioteca.',
      'fecha': 'Hoy, 08:15',
      'tipo': 'Préstamo',
      'icono': Icons.access_time,
      'leida': false,
    },
    {
      'titulo': 'Nueva colección disponible',
      'mensaje':
          'Ya puedes consultar nuevos materiales de la categoría Ingeniería en el catálogo.',
      'fecha': 'Ayer, 14:20',
      'tipo': 'Aviso',
      'icono': Icons.library_books_outlined,
      'leida': true,
    },
    {
      'titulo': 'Solicitud recibida',
      'mensaje':
          'La biblioteca ha recibido tu solicitud y se encuentra pendiente de revisión.',
      'fecha': 'Ayer, 10:45',
      'tipo': 'Reserva',
      'icono': Icons.notifications_active_outlined,
      'leida': true,
    },
    {
      'titulo': 'Aviso de biblioteca',
      'mensaje':
          'Consulta los horarios de atención de la biblioteca antes de acudir.',
      'fecha': '15 Nov, 12:00',
      'tipo': 'Aviso',
      'icono': Icons.info_outline,
      'leida': true,
    },
  ];

  int get _noLeidas =>
      _notificaciones.where((n) => n['leida'] == false).length;

  List<Map<String, dynamic>> get _notificacionesFiltradas {
    if (_filtroSeleccionado == 'No leídas') {
      return _notificaciones
          .where((n) => n['leida'] == false)
          .toList();
    }

    return _notificaciones;
  }

  void _marcarComoLeida(int index) {
    setState(() {
      _notificaciones[index]['leida'] = true;
    });
  }

  void _marcarTodasComoLeidas() {
    setState(() {
      for (var notificacion in _notificaciones) {
        notificacion['leida'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todas las notificaciones están leídas.'),
      ),
    );
  }

  Color _colorTipo(String tipo) {
    switch (tipo) {
      case 'Reserva':
        return Colors.deepOrange;
      case 'Préstamo':
        return Colors.blue;
      case 'Aviso':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _mostrarDetalle(Map<String, dynamic> notificacion) {
    final index = _notificaciones.indexOf(notificacion);

    _marcarComoLeida(index);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          icon: Icon(
            notificacion['icono'],
            size: 45,
            color: primaryColor,
          ),
          title: Text(
            notificacion['titulo'],
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                notificacion['mensaje'],
                textAlign: TextAlign.center,
                style: const TextStyle(height: 1.5),
              ),
              const SizedBox(height: 15),
              Text(
                notificacion['fecha'],
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cerrar',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _crearTarjeta(
    Map<String, dynamic> notificacion,
  ) {
    final bool leida = notificacion['leida'];
    final Color color = _colorTipo(notificacion['tipo']);

    return Card(
      elevation: 1,
      color: leida ? Colors.white : Colors.orange.shade50,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: leida
              ? Colors.grey.shade100
              : Colors.orange.shade100,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _mostrarDetalle(notificacion),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  notificacion['icono'],
                  color: color,
                  size: 25,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notificacion['titulo'],
                            style: TextStyle(
                              fontWeight: leida
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (!leida)
                          Container(
                            width: 9,
                            height: 9,
                            decoration: const BoxDecoration(
                              color: Colors.deepOrange,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      notificacion['mensaje'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            notificacion['tipo'],
                            style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const Spacer(),

                        Text(
                          notificacion['fecha'],
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificaciones = _notificacionesFiltradas;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text(
          'Notificaciones',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_noLeidas > 0)
            TextButton(
              onPressed: _marcarTodasComoLeidas,
              child: const Text(
                'Leer todas',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),

      body: Column(
        children: [
          // RESUMEN
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 18),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.white,
                  size: 38,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Centro de notificaciones',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _noLeidas == 0
                            ? 'No tienes notificaciones pendientes.'
                            : 'Tienes $_noLeidas notificaciones sin leer.',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // FILTROS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _crearFiltro('Todas'),
                const SizedBox(width: 10),
                _crearFiltro('No leídas'),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // LISTA
          Expanded(
            child: notificaciones.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 65,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No tienes notificaciones nuevas',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Aquí aparecerán tus próximos avisos.',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    itemCount: notificaciones.length,
                    itemBuilder: (context, index) {
                      return _crearTarjeta(
                        notificaciones[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _crearFiltro(String texto) {
    final bool seleccionado =
        _filtroSeleccionado == texto;

    return ChoiceChip(
      label: Text(texto),
      selected: seleccionado,
      selectedColor: Colors.deepOrange,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: seleccionado ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: seleccionado
            ? Colors.deepOrange
            : Colors.grey.shade300,
      ),
      onSelected: (_) {
        setState(() {
          _filtroSeleccionado = texto;
        });
      },
    );
  }
}
