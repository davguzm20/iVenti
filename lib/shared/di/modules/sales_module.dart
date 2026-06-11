import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/features/sales/repositories/VentaRepository.dart';
import 'package:iventi/features/sales/repositories/ReciboRepository.dart';
import 'package:iventi/features/sales/services/VentaService.dart';
import 'package:iventi/features/sales/services/PagoService.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';
import 'package:iventi/features/inventory/repositories/LoteRepository.dart';
import 'package:iventi/features/inventory/repositories/ProductoRepository.dart';
import 'package:iventi/features/inventory/repositories/IProductoRepository.dart';
import 'package:iventi/features/inventory/repositories/ILoteRepository.dart';
import 'package:iventi/features/clients/repositories/IClienteRepository.dart';

class SalesModule {
  static late final VentaRepository ventaRepository;
  static late final ReciboRepository reciboRepository;
  static late final VentaService ventaService;
  static late final PagoService pagoService;
  static late final VentaController ventaController;

  static void registerRepositories(
    PostgresDatasource datasource,
    LoteRepository loteRepository,
    ProductoRepository productoRepository,
  ) {
    ventaRepository = VentaRepository(datasource);
    reciboRepository = ReciboRepository(datasource);
  }

  static void registerServices(
    PostgresDatasource datasource,
    IClienteRepository clienteRepository,
    IProductoRepository productoRepository,
    ILoteRepository loteRepository,
  ) {
    ventaService = VentaService(
      datasource,
      ventaRepository,
      productoRepository,
      loteRepository,
      clienteRepository,
    );
    pagoService = PagoService(
      datasource,
      ventaRepository,
      reciboRepository,
      clienteRepository,
    );
  }

  static void registerController() {
    ventaController = VentaController(ventaService, pagoService);
  }
}
