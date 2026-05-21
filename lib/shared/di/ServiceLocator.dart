import 'package:provider/provider.dart';

import 'package:iventi/shared/utils/PostgresDatasource.dart';

// Autenticación
import 'package:iventi/features/auth/repositories/UsuarioRepository.dart';
import 'package:iventi/features/auth/services/AuthService.dart';
import 'package:iventi/features/auth/controllers/AuthController.dart';

// Clientes
import 'package:iventi/features/clients/repositories/ClienteRepository.dart';
import 'package:iventi/features/clients/services/ClienteService.dart';
import 'package:iventi/features/clients/controllers/ClienteController.dart';

// Inventario
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

// Ventas
import 'package:iventi/features/sales/repositories/VentaRepository.dart';
import 'package:iventi/features/sales/repositories/ReciboRepository.dart';
import 'package:iventi/features/sales/services/VentaService.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';

// Configuración
import 'package:iventi/features/config/repositories/ConfiguracionRepository.dart';
import 'package:iventi/features/config/services/ConfiguracionService.dart';
import 'package:iventi/features/config/controllers/ConfiguracionController.dart';

// Notificaciones
import 'package:iventi/features/notifications/repositories/NotificacionRepository.dart';
import 'package:iventi/features/notifications/services/NotificacionService.dart';
import 'package:iventi/features/notifications/controllers/NotificacionController.dart';

// Reportes
import 'package:iventi/features/reports/repositories/ReportRepository.dart';
import 'package:iventi/features/reports/services/ReportService.dart';
import 'package:iventi/features/reports/controllers/ReportController.dart';

class ServiceLocator {
  static late final PostgresDatasource datasource;

  // Autenticación
  static late final UsuarioRepository usuarioRepository;
  static late final AuthService authService;
  static late final AuthController authController;

  // Clientes
  static late final ClienteRepository clienteRepository;
  static late final ClienteService clienteService;
  static late final ClienteController clienteController;

  // Inventario - Repositorios
  static late final ProductoRepository productoRepository;
  static late final CategoriaRepository categoriaRepository;
  static late final UnidadRepository unidadRepository;
  static late final LoteRepository loteRepository;

  // Inventario - Servicios
  static late final ProductoService productoService;
  static late final CategoriaService categoriaService;
  static late final UnidadService unidadService;
  static late final LoteService loteService;

  // Inventario - Controladores
  static late final ProductoController productoController;
  static late final CategoriaController categoriaController;
  static late final UnidadController unidadController;
  static late final LoteController loteController;

  // Ventas
  static late final VentaRepository ventaRepository;
  static late final ReciboRepository reciboRepository;
  static late final VentaService ventaService;
  static late final VentaController ventaController;

  // Configuración
  static late final ConfiguracionRepository configuracionRepository;
  static late final ConfiguracionService configuracionService;
  static late final ConfiguracionController configuracionController;

  // Notificaciones
  static late final NotificacionRepository notificacionRepository;
  static late final NotificacionService notificacionService;
  static late final NotificacionController notificacionController;

  // Reportes
  static late final ReportRepository reportRepository;
  static late final ReportService reportService;
  static late final ReportController reportController;

  static Future<void> initialize() async {
    datasource = PostgresDatasource();

    // === Autenticación ===
    usuarioRepository = UsuarioRepository(datasource);
    authService = AuthService(usuarioRepository);
    authController = AuthController(authService);

    // === Clientes ===
    clienteRepository = ClienteRepository(datasource);
    clienteService = ClienteService(clienteRepository);
    clienteController = ClienteController(clienteService);

    // === Repositorios de Inventario ===
    productoRepository = ProductoRepository(datasource);
    categoriaRepository = CategoriaRepository(datasource);
    unidadRepository = UnidadRepository(datasource);
    loteRepository = LoteRepository(datasource, productoRepository);

    // === Repositorios de Ventas ===
    // VentaRepository depende de loteRepository y productoRepository
    ventaRepository = VentaRepository(datasource, loteRepository, productoRepository);
    reciboRepository = ReciboRepository(datasource);

    // === Repositorio de Configuración ===
    configuracionRepository = ConfiguracionRepository(datasource);

    // === Servicios de Inventario ===
    productoService = ProductoService(productoRepository, categoriaRepository);
    categoriaService = CategoriaService(categoriaRepository);
    unidadService = UnidadService(unidadRepository);
    // LoteService depende de ventaRepository
    loteService = LoteService(loteRepository, productoRepository, ventaRepository);

    // === Servicios de Ventas ===
    ventaService = VentaService(
      datasource,
      ventaRepository,
      reciboRepository,
      productoRepository,
      loteRepository,
      clienteRepository,
    );

    // === Servicio de Configuración ===
    configuracionService = ConfiguracionService(configuracionRepository);

    // === Servicio de Notificaciones ===
    notificacionRepository = NotificacionRepository(datasource);
    notificacionService = NotificacionService(
      notificacionRepository,
      productoRepository,
      loteRepository,
      configuracionRepository,
    );

    // === Controladores de Inventario ===
    productoController = ProductoController(productoService);
    loteController = LoteController(loteService);
    categoriaController = CategoriaController(categoriaService);
    unidadController = UnidadController(unidadService);

    // === Controladores de Ventas ===
    ventaController = VentaController(ventaService);

    // === Controlador de Configuración ===
    configuracionController = ConfiguracionController(configuracionService);

    // === Controlador de Notificaciones ===
    notificacionController = NotificacionController(notificacionService);

    // === Reportes ===
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
