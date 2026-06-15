import 'package:iventi/shared/di/modules/auth_module.dart';
import 'package:iventi/shared/di/modules/clients_module.dart';
import 'package:iventi/shared/di/modules/config_module.dart';
import 'package:iventi/shared/di/modules/inventory_module.dart';
import 'package:iventi/shared/di/modules/notifications_module.dart';
import 'package:iventi/shared/di/modules/reports_module.dart';
import 'package:iventi/shared/di/modules/sales_module.dart';
import 'package:mockito/mockito.dart';
import '../mocks_mocks.dart';

MockAuthController mockAuthController = MockAuthController();
MockClienteController mockClienteController = MockClienteController();
MockConfiguracionController mockConfigController = MockConfiguracionController();
MockProductoController mockProductoController = MockProductoController();
MockCategoriaController mockCategoriaController = MockCategoriaController();
MockUnidadController mockUnidadController = MockUnidadController();
MockLoteController mockLoteController = MockLoteController();
MockNotificacionController mockNotificacionController = MockNotificacionController();
MockReportController mockReportController = MockReportController();
MockVentaController mockVentaController = MockVentaController();

void setupModuleMocks() {
  AuthModule.authController = mockAuthController;
  ClienteModule.clienteController = mockClienteController;
  ConfigModule.configuracionController = mockConfigController;
  InventoryModule.productoController = mockProductoController;
  InventoryModule.categoriaController = mockCategoriaController;
  InventoryModule.unidadController = mockUnidadController;
  InventoryModule.loteController = mockLoteController;
  NotificationsModule.notificacionController = mockNotificacionController;
  ReportsModule.reportController = mockReportController;
  SalesModule.ventaController = mockVentaController;
}

void resetModuleMocks() {
  reset(mockAuthController);
  reset(mockClienteController);
  reset(mockConfigController);
  reset(mockProductoController);
  reset(mockCategoriaController);
  reset(mockUnidadController);
  reset(mockLoteController);
  reset(mockNotificacionController);
  reset(mockReportController);
  reset(mockVentaController);
}
