import 'package:iventi/features/sales/entities/ReciboEntity.dart';
import 'package:iventi/features/sales/dtos/requests/CrearReciboRequest.dart';

abstract class IReciboRepository {
  Future<ReciboEntity> crearReciboConRequest(CrearReciboRequest request);
  Future<List<ReciboEntity>> obtenerRecibosPorVenta(int idVenta);
}
