import 'package:provider/provider.dart';

import 'package:iventi/shared/utils/PostgresDatasource.dart';

// Auth
import 'package:iventi/features/auth/repositories/UsuarioRepository.dart';
import 'package:iventi/features/auth/services/AuthService.dart';
import 'package:iventi/features/auth/controllers/AuthController.dart';

// Clients
import 'package:iventi/features/clients/repositories/ClienteRepository.dart';
import 'package:iventi/features/clients/services/ClienteService.dart';
import 'package:iventi/features/clients/controllers/ClienteController.dart';

// Inventory
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

// Sales
import 'package:iventi/features/sales/repositories/VentaRepository.dart';
import 'package:iventi/features/sales/repositories/ReciboRepository.dart';
import 'package:iventi/features/sales/services/VentaService.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';

// Config
import 'package:iventi/features/config/repositories/ConfiguracionRepository.dart';
import 'package:iventi/features/config/services/ConfiguracionService.dart';
import 'package:iventi/features/config/controllers/ConfiguracionController.dart';

// Notifications
import 'package:iventi/features/notifications/repositories/NotificacionRepository.dart';
import 'package:iventi/features/notifications/services/NotificacionService.dart';
import 'package:iventi/features/notifications/controllers/NotificacionController.dart';

// Reports
import 'package:iventi/features/reports/repositories/ReportRepository.dart';
import 'package:iventi/features/reports/services/ReportService.dart';
import 'package:iventi/features/reports/controllers/ReportController.dart';

class ServiceLocator {
  static late final PostgresDatasource datasource;

  // Auth
  static late final UsuarioRepository usuarioRepository;
  static late final AuthService authService;
  static late final AuthController authController;

  // Clients
  static late final ClienteRepository clienteRepository;
  static late final ClienteService clienteService;
  static late final ClienteController clienteController;

  // Inventory - Repositories
  static late final ProductoRepository productoRepository;
  static late final CategoriaRepository categoriaRepository;
  static late final UnidadRepository unidadRepository;
  static late final LoteRepository loteRepository;

  // Inventory - Services
  static late final ProductoService productoService;
  static late final CategoriaService categoriaService;
  static late final UnidadService unidadService;
  static late final LoteService loteService;

  // Inventory - Controllers
  static late final ProductoController productoController;
  static late final CategoriaController categoriaController;
  static late final UnidadController unidadController;
  static late final LoteController loteController;

  // Sales
  static late final VentaRepository ventaRepository;
  static late final ReciboRepository reciboRepository;
  static late final VentaService ventaService;
  static late final VentaController ventaController;

  // Config
  static late final ConfiguracionRepository configuracionRepository;
  static late final ConfiguracionService configuracionService;
  static late final ConfiguracionController configuracionController;

  // Notifications
  static late final NotificacionRepository notificacionRepository;
  static late final NotificacionService notificacionService;
  static late final NotificacionController notificacionController;

  // Reports
  static late final ReportRepository reportRepository;
  static late final ReportService reportService;
  static late final ReportController reportController;

  static Future<void> initialize() async {
    datasource = PostgresDatasource();

    // === Auth ===
    usuarioRepository = UsuarioRepository(datasource);
    authService = AuthService(usuarioRepository);
    authController = AuthController(authService);

    // === Clients ===
    clienteRepository = ClienteRepository(datasource);
    clienteService = ClienteService(clienteRepository);
    clienteController = ClienteController(clienteService);

    // === Inventory Repositories ===
    productoRepository = ProductoRepository(datasource);
    categoriaRepository = CategoriaRepository(datasource);
    unidadRepository = UnidadRepository(datasource);
    loteRepository = LoteRepository(datasource, productoRepository);

    // === Sales Repositories ===
    // VentaRepository depends on loteRepository y productoRepository
    ventaRepository = VentaRepository(datasource, loteRepository, productoRepository);
    reciboRepository = ReciboRepository(datasource);

    // === Config Repository ===
    configuracionRepository = ConfiguracionRepository(datasource);

    // === Inventory Services ===
    productoService = ProductoService(productoRepository, categoriaRepository);
    categoriaService = CategoriaService(categoriaRepository);
    unidadService = UnidadService(unidadRepository);
    // LoteService depends on ventaRepository
    loteService = LoteService(loteRepository, productoRepository, ventaRepository);

    // === Sales Services ===
    ventaService = VentaService(
      datasource,
      ventaRepository,
      reciboRepository,
      productoRepository,
      loteRepository,
      clienteRepository,
    );

    // === Config Service ===
    configuracionService = ConfiguracionService(configuracionRepository);

    // === Notification Service ===
    notificacionRepository = NotificacionRepository(datasource);
    notificacionService = NotificacionService(
      notificacionRepository,
      productoRepository,
      loteRepository,
      configuracionRepository,
    );

    // === Inventory Controllers ===
    productoController = ProductoController(productoService);
    loteController = LoteController(loteService);
    categoriaController = CategoriaController(categoriaService);
    unidadController = UnidadController(unidadService);

    // === Sales Controllers ===
    ventaController = VentaController(ventaService);

    // === Config Controller ===
    configuracionController = ConfiguracionController(configuracionService);

    // === Notification Controller ===
    notificacionController = NotificacionController(notificacionService);

    // === Reports ===
    reportRepository = ReportRepository(datasource);
    reportService = ReportService(reportRepository);
    reportController = ReportController(reportService);
  }

  static int? usuarioActualId;

  static Future<void> setUsuarioActual(int idUsuario) async {
    usuarioActualId = idUsuario;
    await datasource.connection;
  }

  static List<Provider> get providers => [
    Provider.value(value: authController),
    Provider.value(value: clienteController),
    Provider.value(value: productoController),
    Provider.value(value: loteController),
    Provider.value(value: categoriaController),
    Provider.value(value: unidadController),
    Provider.value(value: ventaController),
    Provider.value(value: notificacionController),
    Provider.value(value: configuracionController),
    Provider.value(value: reportController),
  ];
}
