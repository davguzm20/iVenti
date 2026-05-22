import 'package:iventi/features/inventory/entities/UnidadEntity.dart';

abstract class IUnidadRepository {
  Future<List<UnidadEntity>> obtenerUnidades();
  Future<UnidadEntity?> obtenerUnidadPorId(int idUnidad);
}
