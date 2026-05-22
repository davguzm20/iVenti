import 'package:mockito/annotations.dart';
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
import 'package:iventi/features/sales/services/ReciboService.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';
import 'package:iventi/features/sales/controllers/ReciboController.dart';

// Reports
import 'package:iventi/features/reports/repositories/ReportRepository.dart';
import 'package:iventi/features/reports/services/ReportService.dart';
import 'package:iventi/features/reports/controllers/ReportController.dart';

// Notifications
import 'package:iventi/features/notifications/repositories/NotificacionRepository.dart';
import 'package:iventi/features/notifications/services/NotificacionService.dart';
import 'package:iventi/features/notifications/controllers/NotificacionController.dart';

// Config
import 'package:iventi/features/config/repositories/ConfiguracionRepository.dart';
import 'package:iventi/features/config/services/ConfiguracionService.dart';
import 'package:iventi/features/config/controllers/ConfiguracionController.dart';

@GenerateMocks([PostgresDatasource])
@GenerateMocks([UsuarioRepository])
@GenerateMocks([AuthService])
@GenerateMocks([AuthController])
@GenerateMocks([ClienteRepository])
@GenerateMocks([ClienteService])
@GenerateMocks([ClienteController])
@GenerateMocks([ProductoRepository])
@GenerateMocks([LoteRepository])
@GenerateMocks([CategoriaRepository])
@GenerateMocks([UnidadRepository])
@GenerateMocks([ProductoService])
@GenerateMocks([LoteService])
@GenerateMocks([CategoriaService])
@GenerateMocks([UnidadService])
@GenerateMocks([ProductoController])
@GenerateMocks([LoteController])
@GenerateMocks([CategoriaController])
@GenerateMocks([UnidadController])
@GenerateMocks([VentaRepository])
@GenerateMocks([ReciboRepository])
@GenerateMocks([VentaService])
@GenerateMocks([ReciboService])
@GenerateMocks([VentaController])
@GenerateMocks([ReciboController])
@GenerateMocks([ReportRepository])
@GenerateMocks([ReportService])
@GenerateMocks([ReportController])
@GenerateMocks([NotificacionRepository])
@GenerateMocks([NotificacionService])
@GenerateMocks([NotificacionController])
@GenerateMocks([ConfiguracionRepository])
@GenerateMocks([ConfiguracionService])
@GenerateMocks([ConfiguracionController])
void main() {}
