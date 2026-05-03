import 'package:iventi/features/inventory/entities/LoteEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearLoteRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarLoteRequest.dart';
import 'package:iventi/features/inventory/services/LoteService.dart';

class LoteController {
  final LoteService _loteService;

  LoteController(this._loteService);

  Future<LoteEntity> crearLote(CrearLoteRequest request) {
    return _loteService.crearLote(request);
  }

  Future<LoteEntity> actualizarLote(ActualizarLoteRequest request) {
    return _loteService.actualizarLote(request);
  }

  Future<void> eliminarLote(int idProducto, int idLote) {
    return _loteService.eliminarLote(idProducto, idLote);
  }

  Future<LoteEntity?> obtenerLotePorId(int idProducto, int idLote) {
    return _loteService.obtenerLotePorId(idProducto, idLote);
  }

  Future<List<LoteEntity>> obtenerLotesDeProducto(int idProducto) {
    return _loteService.obtenerLotesDeProducto(idProducto);
  }

  Future<List<LoteEntity>> obtenerLotesPorFechas(DateTime fechaInicio, DateTime fechaFinal) {
    return _loteService.obtenerLotesPorFechas(fechaInicio, fechaFinal);
  }

  Future<List<LoteEntity>> obtenerLotesProximosAVencer(int dias) {
    return _loteService.obtenerLotesProximosAVencer(dias);
  }
}
