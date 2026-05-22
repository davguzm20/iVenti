import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/inventory/entities/UnidadEntity.dart';
import 'package:iventi/features/inventory/repositories/IUnidadRepository.dart';

class UnidadService {
  final IUnidadRepository _unidadRepository;

  UnidadService(this._unidadRepository);

  Future<List<UnidadEntity>> obtenerTodas() async {
    try {
      return await _unidadRepository.obtenerUnidades();

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener unidades: ${e.mensaje}');
    }
  }

  Future<UnidadEntity?> obtenerPorId(int idUnidad) async {
    try {
      return await _unidadRepository.obtenerUnidadPorId(idUnidad);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener unidad: ${e.mensaje}');
    }
  }
}
