import 'package:postgres/postgres.dart';
import 'package:iventi/shared/datasources/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/shared/exceptions/NotFoundException.dart';
import 'package:iventi/features/notifications/entities/NotificacionEntity.dart';
import 'package:iventi/features/notifications/dtos/requests/CrearNotificacionRequest.dart';
import 'package:iventi/features/notifications/mappers/NotificacionMapper.dart';

class NotificacionRepository {
  final PostgresDatasource _datasource;

  NotificacionRepository(this._datasource);

  Future<Connection> get _conexion => _datasource.connection;

  Future<NotificacionEntity> crearNotificacion(CrearNotificacionRequest request) async {
    final conexion = await _conexion;

    try {
      final notificacionCreada = await conexion.execute(
        Sql.named('INSERT INTO notificaciones (id_usuario, id_producto, id_lote, tipo, titulo, contenido, creado_en) VALUES (@id_usuario, @id_producto, @id_lote, @tipo, @titulo, @contenido, CURRENT_TIMESTAMP) RETURNING *'),
        parameters: {
          'id_usuario': request.idUsuario,
          'id_producto': request.idProducto,
          'id_lote': request.idLote,
          'tipo': request.tipo.name,
          'titulo': request.titulo.trim(),
          'contenido': request.contenido.trim(),
        },
      );

      return NotificacionMapper.fromMap(notificacionCreada.first.toColumnMap());
    } catch (e) {
      throw DatabaseException('Error al crear notificacion: $e');
    }
  }

  Future<List<NotificacionEntity>> obtenerNotificaciones(int idUsuario) async {
    final conexion = await _conexion;

    try {
      final notificacionesEncontradas = await conexion.execute(
        Sql.named('SELECT * FROM notificaciones WHERE id_usuario = @id_usuario ORDER BY creado_en DESC'),
        parameters: {'id_usuario': idUsuario},
      );

      return notificacionesEncontradas
          .map((fila) => NotificacionMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener notificaciones: $e');
    }
  }

  Future<List<NotificacionEntity>> obtenerNotificacionesNoLeidas(int idUsuario) async {
    final conexion = await _conexion;

    try {
      final notificacionesEncontradas = await conexion.execute(
        Sql.named('SELECT * FROM notificaciones WHERE id_usuario = @id_usuario AND leida = FALSE ORDER BY creado_en DESC'),
        parameters: {'id_usuario': idUsuario},
      );

      return notificacionesEncontradas
          .map((fila) => NotificacionMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener notificaciones no leidas: $e');
    }
  }

  Future<int> contarNotificacionesNoLeidas(int idUsuario) async {
    final conexion = await _conexion;

    try {
      final totalNoLeidas = await conexion.execute(
        Sql.named('SELECT COUNT(*) AS total FROM notificaciones WHERE id_usuario = @id_usuario AND leida = FALSE'),
        parameters: {'id_usuario': idUsuario},
      );

      return totalNoLeidas.first.toColumnMap()['total'] as int;
    } catch (e) {
      throw DatabaseException('Error al contar notificaciones: $e');
    }
  }

  Future<void> marcarComoLeida(int idNotificacion) async {
    final conexion = await _conexion;

    try {
      final notificacionActualizada = await conexion.execute(
        Sql.named('UPDATE notificaciones SET leida = TRUE WHERE id_notificacion = @id'),
        parameters: {'id': idNotificacion},
      );

      if (notificacionActualizada.affectedRows == 0) {
        throw NotFoundException('Notificacion no encontrada');
      }
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al marcar notificacion como leida: $e');
    }
  }

  Future<void> marcarTodasComoLeidas(int idUsuario) async {
    final conexion = await _conexion;

    try {
      await conexion.execute(
        Sql.named('UPDATE notificaciones SET leida = TRUE WHERE id_usuario = @id_usuario AND leida = FALSE'),
        parameters: {'id_usuario': idUsuario},
      );
    } catch (e) {
      throw DatabaseException('Error al marcar notificaciones como leidas: $e');
    }
  }

  Future<void> eliminarNotificacion(int idNotificacion) async {
    final conexion = await _conexion;

    try {
      final notificacionEliminada = await conexion.execute(
        Sql.named('DELETE FROM notificaciones WHERE id_notificacion = @id'),
        parameters: {'id': idNotificacion},
      );

      if (notificacionEliminada.affectedRows == 0) {
        throw NotFoundException('Notificacion no encontrada');
      }
    } catch (e) {
      if (e is NotFoundException) rethrow;

      throw DatabaseException('Error al eliminar notificacion: $e');
    }
  }

  Future<void> limpiarHistorial(int idUsuario) async {
    final conexion = await _conexion;

    try {
      await conexion.execute(
        Sql.named('DELETE FROM notificaciones WHERE id_usuario = @id_usuario'),
        parameters: {'id_usuario': idUsuario},
      );
    } catch (e) {
      throw DatabaseException('Error al limpiar historial: $e');
    }
  }
}
