import 'package:mockito/annotations.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';

// Auth
import 'package:iventi/features/auth/repositories/IUsuarioRepository.dart';
import 'package:iventi/features/auth/services/AuthService.dart';
import 'package:iventi/features/auth/controllers/AuthController.dart';

// Clients
import 'package:iventi/features/clients/repositories/IClienteRepository.dart';
import 'package:iventi/features/clients/services/ClienteService.dart';
import 'package:iventi/features/clients/controllers/ClienteController.dart';

// Inventory
import 'package:iventi/features/inventory/repositories/IProductoRepository.dart';
import 'package:iventi/features/inventory/repositories/ILoteRepository.dart';
import 'package:iventi/features/inventory/repositories/ICategoriaRepository.dart';
import 'package:iventi/features/inventory/repositories/IUnidadRepository.dart';
import 'package:iventi/features/inventory/services/ProductoService.dart';
import 'package:iventi/features/inventory/services/LoteService.dart';
import 'package:iventi/features/inventory/services/CategoriaService.dart';
import 'package:iventi/features/inventory/services/UnidadService.dart';
import 'package:iventi/features/inventory/controllers/ProductoController.dart';
import 'package:iventi/features/inventory/controllers/LoteController.dart';
import 'package:iventi/features/inventory/controllers/CategoriaController.dart';
import 'package:iventi/features/inventory/controllers/UnidadController.dart';

// Sales
import 'package:iventi/features/sales/repositories/IVentaRepository.dart';
import 'package:iventi/features/sales/repositories/IReciboRepository.dart';
import 'package:iventi/features/sales/services/VentaService.dart';
import 'package:iventi/features/sales/services/PagoService.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';
import 'package:iventi/features/clients/repositories/IClienteRepository.dart';

// Reports
import 'package:iventi/features/reports/repositories/IReportRepository.dart';
import 'package:iventi/features/reports/services/ReportService.dart';
import 'package:iventi/features/reports/controllers/ReportController.dart';

// Notifications
import 'package:iventi/features/notifications/repositories/INotificacionRepository.dart';
import 'package:iventi/features/notifications/services/NotificacionService.dart';
import 'package:iventi/features/notifications/controllers/NotificacionController.dart';

// Config
import 'package:iventi/features/config/repositories/IConfiguracionRepository.dart';
import 'package:iventi/features/config/services/ConfiguracionService.dart';
import 'package:iventi/features/config/controllers/ConfiguracionController.dart';

@GenerateMocks([PostgresDatasource])

// Auth
@GenerateMocks([IUsuarioRepository])
@GenerateMocks([AuthService])
@GenerateMocks([AuthController])

// Clients
@GenerateMocks([IClienteRepository])
@GenerateMocks([ClienteService])
@GenerateMocks([ClienteController])

// Inventory
@GenerateMocks([IProductoRepository])
@GenerateMocks([ILoteRepository])
@GenerateMocks([ICategoriaRepository])
@GenerateMocks([IUnidadRepository])
@GenerateMocks([ProductoService])
@GenerateMocks([LoteService])
@GenerateMocks([CategoriaService])
@GenerateMocks([UnidadService])
@GenerateMocks([ProductoController])
@GenerateMocks([LoteController])
@GenerateMocks([CategoriaController])
@GenerateMocks([UnidadController])

// Sales
@GenerateMocks([IVentaRepository])
@GenerateMocks([IReciboRepository])
@GenerateMocks([VentaService])
@GenerateMocks([PagoService])
@GenerateMocks([VentaController])

// Reports
@GenerateMocks([IReportRepository])
@GenerateMocks([ReportService])
@GenerateMocks([ReportController])

// Notifications
@GenerateMocks([INotificacionRepository])
@GenerateMocks([NotificacionService])
@GenerateMocks([NotificacionController])

// Config
@GenerateMocks([IConfiguracionRepository])
@GenerateMocks([ConfiguracionService])
@GenerateMocks([ConfiguracionController])
void main() {}
