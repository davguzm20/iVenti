import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/features/clients/repositories/ClienteRepository.dart';
import 'package:iventi/features/clients/services/ClienteService.dart';
import 'package:iventi/features/clients/controllers/ClienteController.dart';

class ClienteModule {
  static late final ClienteRepository clienteRepository;
  static late final ClienteService clienteService;
  static late final ClienteController clienteController;

  static void register(PostgresDatasource datasource) {
    clienteRepository = ClienteRepository(datasource);
    clienteService = ClienteService(clienteRepository);
    clienteController = ClienteController(clienteService);
  }
}
