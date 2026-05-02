import 'package:flutter/material.dart';
import 'package:iventi/shared/datasources/database_connection.dart';

class NotificacionEntity {
  final int? idNotificacion;
  final int? idUsuario;
  final int? idProducto;
  final int? idLote;
  final String tipo;
  final String titulo;
  final String contenido;
  final bool leida;
  final String fecha;

  NotificacionEntity({
    this.idNotificacion,
    this.idUsuario,
    this.idProducto,
    this.idLote,
    this.tipo = 'GENERAL',
    required this.titulo,
    required this.contenido,
    this.leida = false,
    required this.fecha,
  });

  NotificacionEntity copyWith({
    int? idNotificacion,
    int? idUsuario,
    int? idProducto,
    int? idLote,
    String? tipo,
    String? titulo,
    String? contenido,
    bool? leida,
    String? fecha,
  }) {
    return NotificacionEntity(
      idNotificacion: idNotificacion ?? this.idNotificacion,
      idUsuario: idUsuario ?? this.idUsuario,
      idProducto: idProducto ?? this.idProducto,
      idLote: idLote ?? this.idLote,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      contenido: contenido ?? this.contenido,
      leida: leida ?? this.leida,
      fecha: fecha ?? this.fecha,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_notificacion': idNotificacion,
      'id_usuario': idUsuario,
      'id_producto': idProducto,
      'id_lote': idLote,
      'tipo': tipo,
      'titulo': titulo,
      'contenido': contenido,
      'leida': leida ? 1 : 0,
      'fecha': fecha,
    };
  }

  factory NotificacionEntity.fromMap(Map<String, dynamic> map) {
    return NotificacionEntity(
      idNotificacion: map['id_notificacion'] as int?,
      idUsuario: map['id_usuario'] as int?,
      idProducto: map['id_producto'] as int?,
      idLote: map['id_lote'] as int?,
      tipo: map['tipo'] as String,
      titulo: map['titulo'] as String,
      contenido: map['contenido'] as String,
      leida: (map['leida'] as int?) == 1,
      fecha: map['fecha'] as String,
    );
  }

  static Future<bool> crearNotificacion(NotificacionEntity notificacion) async {
    try {
      final connection = DatabaseConnection.connection;
      final sql = 'INSERT INTO notificaciones (id_usuario, id_producto, id_lote, tipo, titulo, contenido, leida, fecha) VALUES (?, ?, ?, ?, ?, ?, ?, ?)';
      final result = await connection.query(sql, [
        notificacion.idUsuario,
        notificacion.idProducto,
        notificacion.idLote,
        notificacion.tipo,
        notificacion.titulo,
        notificacion.contenido,
        notificacion.leida,
        notificacion.fecha,
      ]);
      return result.affectedRows > 0;
    } catch (e) {
      debugPrint('Error al insertar notificación: \${e.toString()}');
      return false;
    }
  }

  static Future<List<NotificacionEntity>> obtenerNotificaciones() async {
    List<NotificacionEntity> notificaciones = [];

    try {
      final connection = DatabaseConnection.connection;
      final result = await connection.query('SELECT * FROM notificaciones ORDER BY fecha DESC');

      for (var row in result) {
        notificaciones.add(NotificacionEntity.fromMap({
          'id_notificacion': row['id_notificacion'],
          'id_usuario': row['id_usuario'],
          'id_producto': row['id_producto'],
          'id_lote': row['id_lote'],
          'tipo': row['tipo'],
          'titulo': row['titulo'],
          'contenido': row['contenido'],
          'leida': row['leida'],
          'fecha': row['fecha'],
        }));
      }
    } catch (e) {
      debugPrint('Error al obtener notificaciones: ${e.toString()}');
    }

    return notificaciones;
  }

  static Future<bool> eliminarNotificacion(int idNotificacion) async {
    try {
      final connection = DatabaseConnection.connection;
      final result = await connection.query(
        'DELETE FROM notificaciones WHERE id_notificacion = $1',
        [idNotificacion],
      );
      return result.affectedRows > 0;
    } catch (e) {
      debugPrint('Error al eliminar notificación: ${e.toString()}');
      return false;
    }
  }

  static Future<bool> limpiarHistorial() async {
    try {
      final connection = DatabaseConnection.connection;
      final result = await connection.query('DELETE FROM notificaciones');
      return result.affectedRows > 0;
    } catch (e) {
      debugPrint('Error al limpiar historial: ${e.toString()}');
      return false;
    }
  }

  @override
  String toString() {
    return 'NotificacionEntity(id: $idNotificacion, titulo: $titulo, tipo: $tipo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificacionEntity && other.idNotificacion == idNotificacion;
  }

  @override
  int get hashCode => idNotificacion.hashCode;
}
