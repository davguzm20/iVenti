import 'package:iventi/features/config/entities/ConfiguracionEntity.dart';
import 'package:iventi/features/config/dtos/requests/CrearConfiguracionRequest.dart';
import 'package:iventi/features/config/services/ConfiguracionService.dart';

class ConfiguracionController {
  final ConfiguracionService _configuracionService;

  ConfiguracionController(this._configuracionService);

  Future<ConfiguracionEntity?> obtenerConfiguracion(int idUsuario, String clave) {
    return _configuracionService.obtenerConfiguracion(idUsuario, clave);
  }

  Future<List<ConfiguracionEntity>> obtenerTodas(int idUsuario) {
    return _configuracionService.obtenerTodas(idUsuario);
  }

  Future<ConfiguracionEntity> guardarConfiguracion(CrearConfiguracionRequest request) {
    return _configuracionService.guardarConfiguracion(request);
  }

  Future<void> eliminarConfiguracion(int idConfiguracion) {
    return _configuracionService.eliminarConfiguracion(idConfiguracion);
  }
}
