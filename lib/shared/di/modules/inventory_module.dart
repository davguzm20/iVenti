import 'package:iventi/shared/utils/PostgresDatasource.dart';
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
import 'package:iventi/features/sales/repositories/IVentaRepository.dart';

class InventoryModule {
  static late final ProductoRepository productoRepository;
  static late final CategoriaRepository categoriaRepository;
  static late final UnidadRepository unidadRepository;
  static late final LoteRepository loteRepository;
  static late final ProductoService productoService;
  static late final CategoriaService categoriaService;
  static late final UnidadService unidadService;
  static late final LoteService loteService;
  static late final ProductoController productoController;
  static late final CategoriaController categoriaController;
  static late final UnidadController unidadController;
  static late final LoteController loteController;

  static void registerRepositories(PostgresDatasource datasource) {
    productoRepository = ProductoRepository(datasource);
    categoriaRepository = CategoriaRepository(datasource);
    unidadRepository = UnidadRepository(datasource);
    loteRepository = LoteRepository(datasource, productoRepository);
  }

  static void registerServices(IVentaRepository ventaRepository) {
    productoService = ProductoService(productoRepository, categoriaRepository);
    categoriaService = CategoriaService(categoriaRepository);
    unidadService = UnidadService(unidadRepository);
    loteService = LoteService(loteRepository, productoRepository, ventaRepository);
  }

  static void registerControllers() {
    productoController = ProductoController(productoService);
    loteController = LoteController(loteService);
    categoriaController = CategoriaController(categoriaService);
    unidadController = UnidadController(unidadService);
  }
}
