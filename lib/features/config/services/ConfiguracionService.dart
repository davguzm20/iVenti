import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/config/entities/ConfiguracionEntity.dart';
import 'package:iventi/features/config/dtos/requests/CrearConfiguracionRequest.dart';
import 'package:iventi/features/config/repositories/IConfiguracionRepository.dart';

class ConfiguracionService {
  final IConfiguracionRepository _configuracionRepository;

  ConfiguracionService(this._configuracionRepository);

  Future<ConfiguracionEntity?> obtenerConfiguracion(int idUsuario, String clave) async {
    try {
      return await _configuracionRepository.obtenerConfiguracion(idUsuario, clave);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener configuracion: ${e.mensaje}');
    }
  }

  Future<List<ConfiguracionEntity>> obtenerTodas(int idUsuario) async {
    try {
      return await _configuracionRepository.obtenerTodasConfiguraciones(idUsuario);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener configuraciones: ${e.mensaje}');
    }
  }

  Future<ConfiguracionEntity> guardarConfiguracion(CrearConfiguracionRequest request) async {
    try {
      return await _configuracionRepository.crearOActualizarConfiguracion(request);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al guardar configuracion: ${e.mensaje}');
    }
  }

  Future<void> eliminarConfiguracion(int idConfiguracion) async {
    try {
      await _configuracionRepository.eliminarConfiguracion(idConfiguracion);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al eliminar configuracion: ${e.mensaje}');
    }
  }
}
