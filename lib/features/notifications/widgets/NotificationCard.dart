import 'package:flutter/material.dart';
import 'package:iventi/features/notifications/entities/NotificacionEntity.dart';
import 'package:iventi/features/notifications/enums/TipoNotificacion.dart';

class NotificationCard extends StatelessWidget {
  final NotificacionEntity notification;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onMarkAsRead,
    this.onDelete,
    this.onTap,
  });

  Color _getTipoColor() {
    switch (notification.tipo) {
      case TipoNotificacion.STOCK_BAJO:
        return Colors.orange;
      case TipoNotificacion.STOCK_AGOTADO:
        return Colors.red;
      case TipoNotificacion.PROXIMO_VENCER:
        return Colors.amber;
      case TipoNotificacion.VENCIDO:
        return Colors.red.shade900;
    }
  }

  IconData _getTipoIcon() {
    switch (notification.tipo) {
      case TipoNotificacion.STOCK_BAJO:
        return Icons.inventory_2_outlined;
      case TipoNotificacion.STOCK_AGOTADO:
        return Icons.shopping_cart_outlined;
      case TipoNotificacion.PROXIMO_VENCER:
        return Icons.calendar_today_outlined;
      case TipoNotificacion.VENCIDO:
        return Icons.event_busy;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tipoColor = _getTipoColor();
    final tipoIcon = _getTipoIcon();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: tipoColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  tipoIcon,
                  color: tipoColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.titulo,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notification.leida)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: tipoColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.contenido,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(notification.creadoEn),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (onMarkAsRead != null && !notification.leida)
                              IconButton(
                                icon: const Icon(Icons.done, size: 20),
                                onPressed: onMarkAsRead,
                                tooltip: 'Marcar como leída',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 36,
                                  minHeight: 36,
                                ),
                              ),
                            if (onDelete != null)
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                onPressed: onDelete,
                                tooltip: 'Eliminar',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 36,
                                  minHeight: 36,
                                ),
                              ),
                          ],
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} d';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}