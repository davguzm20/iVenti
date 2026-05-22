import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/features/config/repositories/ConfiguracionRepository.dart';
import 'package:iventi/features/config/services/ConfiguracionService.dart';
import 'package:iventi/features/config/controllers/ConfiguracionController.dart';

class ConfigModule {
  static late final ConfiguracionRepository configuracionRepository;
  static late final ConfiguracionService configuracionService;
  static late final ConfiguracionController configuracionController;

  static void register(PostgresDatasource datasource) {
    configuracionRepository = ConfiguracionRepository(datasource);
    configuracionService = ConfiguracionService(configuracionRepository);
    configuracionController = ConfiguracionController(configuracionService);
  }
}
