import 'package:iventi/features/sales/entities/ReciboEntity.dart';
import 'package:iventi/features/sales/dtos/requests/CrearReciboRequest.dart';
import 'package:iventi/features/sales/services/ReciboService.dart';

class ReciboController {
  final ReciboService _reciboService;

  ReciboController(this._reciboService);

  Future<ReciboEntity> crearRecibo(CrearReciboRequest request) {
    return _reciboService.crearRecibo(request);
  }

  Future<List<ReciboEntity>> obtenerRecibosDeVenta(int idVenta) {
    return _reciboService.obtenerRecibosDeVenta(idVenta);
  }
}
