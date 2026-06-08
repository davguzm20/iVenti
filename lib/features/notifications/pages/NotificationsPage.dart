import 'package:flutter/material.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/features/notifications/entities/NotificacionEntity.dart';
import 'package:iventi/features/notifications/controllers/NotificacionController.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/features/notifications/widgets/NotificationCard.dart';

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

                    return NotificationCard(
                      notification: notif,
                      onMarkAsRead: !notif.leida
                          ? () async {
                              await _controller.marcarComoLeida(notif.idNotificacion!);
                              _cargar();
                            }
                          : null,
                      onDelete: () async {
                        await _controller.eliminarNotificacion(notif.idNotificacion!);
                        _cargar();
                      },
                    );
                  },
                ),
    );
  }
}


