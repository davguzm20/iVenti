import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/sales/entities/ReciboEntity.dart';
import 'package:iventi/features/sales/dtos/requests/CrearReciboRequest.dart';
import 'package:iventi/features/sales/repositories/ReciboRepository.dart';

class ReciboService {
  final ReciboRepository _reciboRepository;

  ReciboService(this._reciboRepository);

  Future<ReciboEntity> crearRecibo(CrearReciboRequest request) async {
    if (request.montoCancelado <= 0) {
      throw BusinessException('El monto debe ser mayor a 0');
    }

    try {
      return await _reciboRepository.crearReciboConRequest(request);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al crear recibo: ${e.mensaje}');
    }
  }

  Future<List<ReciboEntity>> obtenerRecibosDeVenta(int idVenta) async {
    try {
      return await _reciboRepository.obtenerRecibosPorVenta(idVenta);

    } on DatabaseException catch (e) {
      throw BusinessException('Error al obtener recibos: ${e.mensaje}');
    }
  }
}
