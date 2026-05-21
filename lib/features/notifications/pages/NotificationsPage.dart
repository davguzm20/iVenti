import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iventi/features/notifications/entities/NotificacionEntity.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/features/notifications/controllers/NotificacionController.dart';
import 'package:iventi/shared/theme/AppColors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificacionEntity> notificaciones = [];
  bool isLoading = false;

  NotificacionController get _controller =>
      ServiceLocator.notificacionController;

  @override
  void initState() {
    super.initState();

    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => isLoading = true);

    final data = await _controller.obtenerNotificaciones(1);

    if (mounted) {
      setState(() {
        notificaciones = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificaciones"),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.checklist),
            tooltip: "Marcar todas como leídas",
            onPressed: () async { await _controller.marcarTodasComoLeidas(1); _cargar(); },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            tooltip: "Limpiar historial",
            onPressed: () async { await _controller.limpiarHistorial(1); _cargar(); },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notificaciones.isEmpty
              ? const Center(child: Text("No hay notificaciones"))
              : ListView.builder(
                  itemCount: notificaciones.length,
                  itemBuilder: (context, index) {
                    final notif = notificaciones[index];
                    final iconColor = notif.leida ? Colors.grey : AppColors.primary;

                    return Slidable(
                      key: ValueKey(notif.idNotificacion),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          if (!notif.leida)
                            SlidableAction(
                              onPressed: (_) async { await _controller.marcarComoLeida(notif.idNotificacion!); _cargar(); },
                              backgroundColor: Colors.blue, foregroundColor: Colors.white, icon: Icons.check, label: 'Leer',
                            ),
                          SlidableAction(
                            onPressed: (_) async { await _controller.eliminarNotificacion(notif.idNotificacion!); _cargar(); },
                            backgroundColor: Colors.red, foregroundColor: Colors.white, icon: Icons.delete, label: 'Eliminar',
                          ),
                        ],
                      ),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: ListTile(
                          leading: Icon(notif.leida ? Icons.notifications_off : Icons.notifications_active, color: iconColor),
                          title: Text(notif.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notif.contenido),
                              const SizedBox(height: 4),
                              Text(notif.creadoEn.toIso8601String().split('T')[0], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            ],
                          ),
                          trailing: notif.leida
                              ? null
                              : IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () async { await _controller.marcarComoLeida(notif.idNotificacion!); _cargar(); }),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
