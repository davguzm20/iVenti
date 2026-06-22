import 'package:flutter/material.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/features/notifications/entities/NotificacionEntity.dart';
import 'package:iventi/features/notifications/controllers/NotificacionController.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/shared/widgets/LoadingDialog.dart';
import 'package:iventi/features/notifications/widgets/NotificationCard.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificacionEntity> notificaciones = [];
  bool isLoading = false;
  bool _isProcessing = false;

  NotificacionController get _controller =>
      ServiceLocator.notificacionController;

  @override
  void initState() {
    super.initState();

    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => isLoading = true);

    try {
      final data = await _controller.obtenerNotificaciones(ServiceLocator.requireUsuarioActualId);

      if (mounted) {
        setState(() {
          notificaciones = data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error al cargar notificaciones: $e');
      if (mounted) {
        setState(() => isLoading = false);
        final (title, desc) = DialogMessages.notificaciones.errorCargar;
        ErrorDialog(context: context, title: title, description: desc);
      }
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
            onPressed: _isProcessing ? null : () async {
              _isProcessing = true;
              LoadingDialog.show(context);
              try {
                await _controller.marcarTodasComoLeidas(ServiceLocator.requireUsuarioActualId);
                if (!context.mounted) return;
                LoadingDialog.hide(context);
                _isProcessing = false;
                _cargar();
              } catch (e) {
                if (!context.mounted) return;
                LoadingDialog.hide(context);
                _isProcessing = false;
                final (t2, d2) = DialogMessages.notificaciones.errorMarcarLeidas;
                ErrorDialog(context: context, title: t2, description: d2);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            tooltip: "Limpiar historial",
            onPressed: _isProcessing ? null : () async {
              _isProcessing = true;
              LoadingDialog.show(context);
              try {
                await _controller.limpiarHistorial(ServiceLocator.requireUsuarioActualId);
                if (!context.mounted) return;
                LoadingDialog.hide(context);
                _isProcessing = false;
                _cargar();
              } catch (e) {
                if (!context.mounted) return;
                LoadingDialog.hide(context);
                _isProcessing = false;
                final (t3, d3) = DialogMessages.notificaciones.errorLimpiar;
                ErrorDialog(context: context, title: t3, description: d3);
              }
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

                    return NotificationCard(
                      notification: notif,
                      onMarkAsRead: (!notif.leida && !_isProcessing)
                          ? () async {
                              _isProcessing = true;
                              try {
                                await _controller.marcarComoLeida(notif.idNotificacion!);
                                _isProcessing = false;
                                _cargar();
                              } catch (e) {
                                _isProcessing = false;
                              }
                            }
                          : null,
                      onDelete: _isProcessing ? null : () async {
                        _isProcessing = true;
                        try {
                          await _controller.eliminarNotificacion(notif.idNotificacion!);
                          _isProcessing = false;
                          _cargar();
                        } catch (e) {
                          _isProcessing = false;
                        }
                      },
                    );
                  },
                ),
    );
  }
}


