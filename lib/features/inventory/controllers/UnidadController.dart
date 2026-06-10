import 'package:iventi/features/inventory/entities/UnidadEntity.dart';
import 'package:iventi/features/inventory/services/UnidadService.dart';

class UnidadController {
  final UnidadService _unidadService;

  UnidadController(this._unidadService);

  Future<List<UnidadEntity>> obtenerTodas() {
    return _unidadService.obtenerTodas();
  }

  Future<UnidadEntity?> obtenerPorId(int idUnidad) {
    return _unidadService.obtenerPorId(idUnidad);
  }
}
