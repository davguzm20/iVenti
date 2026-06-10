import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/features/notifications/repositories/NotificacionRepository.dart';
import 'package:iventi/features/notifications/services/NotificacionService.dart';
import 'package:iventi/features/notifications/controllers/NotificacionController.dart';
import 'package:iventi/features/inventory/repositories/IProductoRepository.dart';
import 'package:iventi/features/inventory/repositories/ILoteRepository.dart';
import 'package:iventi/features/config/repositories/IConfiguracionRepository.dart';

class NotificationsModule {
  static late final NotificacionRepository notificacionRepository;
  static late final NotificacionService notificacionService;
  static late final NotificacionController notificacionController;

  static void register(
    PostgresDatasource datasource,
    IProductoRepository productoRepository,
    ILoteRepository loteRepository,
    IConfiguracionRepository configuracionRepository,
  ) {
    notificacionRepository = NotificacionRepository(datasource);
    notificacionService = NotificacionService(
      notificacionRepository,
      productoRepository,
      loteRepository,
      configuracionRepository,
    );
    notificacionController = NotificacionController(notificacionService);
  }
}
