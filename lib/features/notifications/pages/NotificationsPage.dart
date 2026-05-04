import 'package:flutter/material.dart';
import 'package:iventi/features/notifications/entities/NotificacionEntity.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/features/notifications/controllers/NotificacionController.dart';
import 'package:iventi/shared/config/AppColors.dart';
import 'package:iventi/shared/config/ButtonStyles.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.checklist),
            onPressed: () async {
              await _controller.marcarTodasComoLeidas(1);
              _cargar();
            },
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

                    return ListTile(
                      leading: Icon(
                        notif.leida
                            ? Icons.notifications_off
                            : Icons.notifications_active,
                        color: notif.leida
                            ? Colors.grey
                            : AppColors.primary,
                      ),
                      title: Text(
                        notif.titulo,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(notif.contenido),
                      trailing: notif.leida
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () async {
                                await _controller
                                    .marcarComoLeida(notif.idNotificacion!);
                                _cargar();
                              },
                            ),
                    );
                  },
                ),
    );
  }
}
