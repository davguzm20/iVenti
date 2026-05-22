import 'package:iventi/features/config/entities/ConfiguracionEntity.dart';
import 'package:iventi/features/config/dtos/requests/CrearConfiguracionRequest.dart';

abstract class IConfiguracionRepository {
  Future<ConfiguracionEntity?> obtenerConfiguracion(int idUsuario, String clave);
  Future<List<ConfiguracionEntity>> obtenerTodasConfiguraciones(int idUsuario);
  Future<ConfiguracionEntity> crearOActualizarConfiguracion(CrearConfiguracionRequest request);
  Future<void> eliminarConfiguracion(int idConfiguracion);
}
