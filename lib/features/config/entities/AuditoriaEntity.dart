import '../enums/OperacionAuditoria.dart';

class AuditoriaEntity {
  final int? idAuditoria;
  final int? idUsuario;
  final String tabla;
  final int registroId;
  final OperacionAuditoria operacion;
  final DateTime fechaAuditoria;
  final String? ipOrigen;
  final String? dispositivo;

  AuditoriaEntity({
    this.idAuditoria,
    this.idUsuario,
    required this.tabla,
    required this.registroId,
    required this.operacion,
    required this.fechaAuditoria,
    this.ipOrigen,
    this.dispositivo,
  });
}
