import 'package:iventi/features/inventory/entities/LoteEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearLoteRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarLoteRequest.dart';

abstract class ILoteRepository {
  Future<LoteEntity> crearLote(CrearLoteRequest request);
  Future<LoteEntity?> obtenerLotePorId(int idProducto, int idLote);
  Future<List<LoteEntity>> obtenerLotesDeProducto(int idProducto);
  Future<LoteEntity> actualizarLote(ActualizarLoteRequest request);
  Future<void> eliminarLote(int idProducto, int idLote);
  Future<List<LoteEntity>> obtenerLotesPorFechas(DateTime fechaInicio, DateTime fechaFinal);
  Future<List<LoteEntity>> obtenerLotesProximosAVencer(int diasAntesVencimiento);
}
