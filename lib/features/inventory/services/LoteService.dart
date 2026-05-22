import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/inventory/entities/LoteEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearLoteRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarLoteRequest.dart';
import 'package:iventi/features/inventory/repositories/ILoteRepository.dart';
import 'package:iventi/features/inventory/repositories/IProductoRepository.dart';
import 'package:iventi/features/sales/repositories/IVentaRepository.dart';

class LoteService {
  final ILoteRepository _loteRepository;
  final IProductoRepository _productoRepository;
  final IVentaRepository _ventaRepository;

  LoteService(this._loteRepository, this._productoRepository, this._ventaRepository);

  Future<LoteEntity> crearLote(CrearLoteRequest request) async {
    final productoExistente = await _productoRepository.obtenerProductoPorId(request.idProducto);

    if (productoExistente == null) {
      throw BusinessException('Producto no encontrado');
    }

    if (request.cantidadComprada <= 0) {
      throw BusinessException('La cantidad comprada debe ser mayor a 0');
    }

    try {
      return await _loteRepository.crearLote(request);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al crear lote: ${e.mensaje}');
    }
  }

  Future<LoteEntity> actualizarLote(ActualizarLoteRequest request) async {
    final loteExistente = await _loteRepository.obtenerLotePorId(request.idProducto, request.idLote);

    if (loteExistente == null) {
      throw BusinessException('Lote no encontrado');
    }

    if (request.cantidadActual < 0) {
      throw BusinessException('La cantidad actual no puede ser negativa');
    }

    try {
      return await _loteRepository.actualizarLote(request);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al actualizar lote: ${e.mensaje}');
    }
  }

  Future<void> eliminarLote(int idProducto, int idLote) async {
    final loteExistente = await _loteRepository.obtenerLotePorId(idProducto, idLote);

    if (loteExistente == null) {
      throw BusinessException('Lote no encontrado');
    }

    final cantidadVendida = await _ventaRepository.obtenerCantidadVendidaPorLote(idLote);

    if (cantidadVendida > 0) {
      throw BusinessException('No se puede eliminar un lote con ventas registradas');
    }

    try {
      await _loteRepository.eliminarLote(idProducto, idLote);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al eliminar lote: ${e.mensaje}');
    }
  }

  Future<LoteEntity?> obtenerLotePorId(int idProducto, int idLote) async {
    try {
      return await _loteRepository.obtenerLotePorId(idProducto, idLote);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener lote: ${e.mensaje}');
    }
  }

  Future<List<LoteEntity>> obtenerLotesDeProducto(int idProducto) async {
    try {
      return await _loteRepository.obtenerLotesDeProducto(idProducto);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener lotes: ${e.mensaje}');
    }
  }

  Future<List<LoteEntity>> obtenerLotesPorFechas(DateTime fechaInicio, DateTime fechaFinal) async {
    try {
      return await _loteRepository.obtenerLotesPorFechas(fechaInicio, fechaFinal);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener lotes por fechas: ${e.mensaje}');
    }
  }

  Future<List<LoteEntity>> obtenerLotesProximosAVencer(int dias) async {
    try {
      return await _loteRepository.obtenerLotesProximosAVencer(dias);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al verificar vencimientos: ${e.mensaje}');
    }
  }
}
