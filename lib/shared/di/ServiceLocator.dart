import 'package:provider/provider.dart';

import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/di/modules/auth_module.dart';
import 'package:iventi/shared/di/modules/clients_module.dart';
import 'package:iventi/shared/di/modules/inventory_module.dart';
import 'package:iventi/shared/di/modules/sales_module.dart';
import 'package:iventi/shared/di/modules/config_module.dart';
import 'package:iventi/shared/di/modules/notifications_module.dart';
import 'package:iventi/shared/di/modules/reports_module.dart';
import 'package:iventi/features/auth/repositories/UsuarioRepository.dart';
import 'package:iventi/features/auth/services/AuthService.dart';
import 'package:iventi/features/auth/controllers/AuthController.dart';
import 'package:iventi/features/clients/repositories/ClienteRepository.dart';
import 'package:iventi/features/clients/services/ClienteService.dart';
import 'package:iventi/features/clients/controllers/ClienteController.dart';
import 'package:iventi/features/inventory/repositories/ProductoRepository.dart';
import 'package:iventi/features/inventory/repositories/LoteRepository.dart';
import 'package:iventi/features/inventory/repositories/CategoriaRepository.dart';
import 'package:iventi/features/inventory/repositories/UnidadRepository.dart';
import 'package:iventi/features/inventory/services/ProductoService.dart';
import 'package:iventi/features/inventory/services/LoteService.dart';
import 'package:iventi/features/inventory/services/CategoriaService.dart';
import 'package:iventi/features/inventory/services/UnidadService.dart';
import 'package:iventi/features/inventory/controllers/ProductoController.dart';
import 'package:iventi/features/inventory/controllers/LoteController.dart';
import 'package:iventi/features/inventory/controllers/CategoriaController.dart';
import 'package:iventi/features/inventory/controllers/UnidadController.dart';
import 'package:iventi/features/sales/repositories/VentaRepository.dart';
import 'package:iventi/features/sales/repositories/ReciboRepository.dart';
import 'package:iventi/features/sales/services/VentaService.dart';
import 'package:iventi/features/sales/services/PagoService.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';
import 'package:iventi/features/config/repositories/ConfiguracionRepository.dart';
import 'package:iventi/features/config/services/ConfiguracionService.dart';
import 'package:iventi/features/config/controllers/ConfiguracionController.dart';
import 'package:iventi/features/notifications/repositories/NotificacionRepository.dart';
import 'package:iventi/features/notifications/services/NotificacionService.dart';
import 'package:iventi/features/notifications/controllers/NotificacionController.dart';
import 'package:iventi/features/reports/repositories/ReportRepository.dart';
import 'package:iventi/features/reports/services/ReportService.dart';
import 'package:iventi/features/reports/controllers/ReportController.dart';

class ServiceLocator {
  static late final PostgresDatasource datasource;

  static Future<void> initialize() async {
    datasource = PostgresDatasource();

    // 1. Módulos sin dependencias cruzadas
    AuthModule.register(datasource);
    ClienteModule.register(datasource);
    ConfigModule.register(datasource);

    // 2. Repositorios con dependencias entre features
    InventoryModule.registerRepositories(datasource);
    SalesModule.registerRepositories(
      datasource,
      InventoryModule.loteRepository,
      InventoryModule.productoRepository,
    );

    // 3. Servicios
    InventoryModule.registerServices(SalesModule.ventaRepository);
    SalesModule.registerServices(
      datasource,
      ClienteModule.clienteRepository,
      InventoryModule.productoRepository,
      InventoryModule.loteRepository,
    );

    // 4. Módulos que dependen de servicios y repositorios de otras features
    NotificationsModule.register(
      datasource,
      InventoryModule.productoRepository,
      InventoryModule.loteRepository,
      ConfigModule.configuracionRepository,
    );
    ReportsModule.register(datasource);

    // 5. Controladores (dependen de servicios ya registrados)
    InventoryModule.registerControllers();
    SalesModule.registerController();
  }

  // Backwards-compatible getters
  static UsuarioRepository get usuarioRepository => AuthModule.usuarioRepository;
  static AuthService get authService => AuthModule.authService;
  static AuthController get authController => AuthModule.authController;
  static ClienteRepository get clienteRepository => ClienteModule.clienteRepository;
  static ClienteService get clienteService => ClienteModule.clienteService;
  static ClienteController get clienteController => ClienteModule.clienteController;
  static ProductoRepository get productoRepository => InventoryModule.productoRepository;
  static CategoriaRepository get categoriaRepository => InventoryModule.categoriaRepository;
  static UnidadRepository get unidadRepository => InventoryModule.unidadRepository;
  static LoteRepository get loteRepository => InventoryModule.loteRepository;
  static ProductoService get productoService => InventoryModule.productoService;
  static CategoriaService get categoriaService => InventoryModule.categoriaService;
  static UnidadService get unidadService => InventoryModule.unidadService;
  static LoteService get loteService => InventoryModule.loteService;
  static ProductoController get productoController => InventoryModule.productoController;
  static CategoriaController get categoriaController => InventoryModule.categoriaController;
  static UnidadController get unidadController => InventoryModule.unidadController;
  static LoteController get loteController => InventoryModule.loteController;
  static VentaRepository get ventaRepository => SalesModule.ventaRepository;
  static ReciboRepository get reciboRepository => SalesModule.reciboRepository;
  static VentaService get ventaService => SalesModule.ventaService;
  static PagoService get pagoService => SalesModule.pagoService;
  static VentaController get ventaController => SalesModule.ventaController;
  static ConfiguracionRepository get configuracionRepository => ConfigModule.configuracionRepository;
  static ConfiguracionService get configuracionService => ConfigModule.configuracionService;
  static ConfiguracionController get configuracionController => ConfigModule.configuracionController;
  static NotificacionRepository get notificacionRepository => NotificationsModule.notificacionRepository;
  static NotificacionService get notificacionService => NotificationsModule.notificacionService;
  static NotificacionController get notificacionController => NotificationsModule.notificacionController;
  static ReportRepository get reportRepository => ReportsModule.reportRepository;
  static ReportService get reportService => ReportsModule.reportService;
  static ReportController get reportController => ReportsModule.reportController;

  static int? usuarioActualId;

  static int get requireUsuarioActualId {
    if (usuarioActualId == null) throw StateError('Usuario no autenticado');
    return usuarioActualId!;
  }

  static Future<void> setUsuarioActual(int idUsuario) async {
    usuarioActualId = idUsuario;
    await datasource.connection;
  }

  static List<Provider> get providers => [
    Provider.value(value: AuthModule.authController),
    Provider.value(value: ClienteModule.clienteController),
    Provider.value(value: InventoryModule.productoController),
    Provider.value(value: InventoryModule.loteController),
    Provider.value(value: InventoryModule.categoriaController),
    Provider.value(value: InventoryModule.unidadController),
    Provider.value(value: SalesModule.ventaController),
    Provider.value(value: NotificationsModule.notificacionController),
    Provider.value(value: ConfigModule.configuracionController),
    Provider.value(value: ReportsModule.reportController),
  ];
}
