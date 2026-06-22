import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DialogMessages {
  DialogMessages._();

  static Map<String, String>? _cache;

  static Future<void> init() async {
    if (_cache != null) return;
    final json = await rootBundle.loadString('lib/shared/utils/messages.arb');
    final data = jsonDecode(json) as Map<String, dynamic>;
    _cache = data.map((k, v) => MapEntry(k, v as String));
  }

  static (String, String) _mensaje(String key) {
    final titulo = _cache?['${key}Titulo'] ?? '[$key]';
    final descripcion = _cache?['${key}Descripcion'] ?? '';
    return (titulo, descripcion);
  }

  static (String, String) _mensajeCon(String key, String parametro, {String tag = 'email'}) {
    final titulo = _cache?['${key}Titulo'] ?? '[$key]';
    final descripcion = (_cache?['${key}Descripcion'] ?? '').replaceAll('{$tag}', parametro);
    return (titulo, descripcion);
  }

  static final auth = _AuthMessages();
  static final ventas = _VentasMessages();
  static final inventario = _InventarioMessages();
  static final clientes = _ClientesMessages();
  static final config = _ConfigMessages();
  static final notificaciones = _NotificacionesMessages();
  static final error = _ErrorMessages();
}

class _AuthMessages {
  (String, String) get pinInvalido => DialogMessages._mensaje('authPinInvalido');
  (String, String) get pinNoCoincide => DialogMessages._mensaje('authPinNoCoincide');
  (String, String) codigoEnviado(String email) => DialogMessages._mensajeCon('authCodigoEnviado', email);
  (String, String) get nombreRequerido => DialogMessages._mensaje('authNombreRequerido');
  (String, String) get configuracionCompletada => DialogMessages._mensaje('authConfiguracionCompletada');
  (String, String) get cuentaNoEncontrada => DialogMessages._mensaje('authCuentaNoEncontrada');
  (String, String) get correoNoDisponible => DialogMessages._mensaje('authCorreoNoDisponible');
  (String, String) get diasVencimientoRequerido => DialogMessages._mensaje('authDiasVencimientoRequerido');
  (String, String) get stockMinimoRequerido => DialogMessages._mensaje('authStockMinimoRequerido');
  (String, String) get diasVencimientoInvalido => DialogMessages._mensaje('authDiasVencimientoInvalido');
  (String, String) get stockMinimoInvalido => DialogMessages._mensaje('authStockMinimoInvalido');
  (String, String) get pinIncompleto => DialogMessages._mensaje('authPinIncompleto');
  (String, String) get errorInicioSesion => DialogMessages._mensaje('authErrorInicioSesion');
  (String, String) get emailRequerido => DialogMessages._mensaje('authEmailRequerido');
  (String, String) get emailInvalido => DialogMessages._mensaje('authEmailInvalido');
  (String, String) get errorEnviarCodigo => DialogMessages._mensaje('authErrorEnviarCodigo');
  (String, String) get codigoIncorrecto => DialogMessages._mensaje('authCodigoIncorrecto');
  (String, String) get errorValidarCodigo => DialogMessages._mensaje('authErrorValidarCodigo');
  (String, String) get noSePudoRecuperarPIN => DialogMessages._mensaje('authNoSePudoRecuperarPIN');
}

class _VentasMessages {
  (String, String) get montoInsuficiente => DialogMessages._mensaje('ventasMontoInsuficiente');
  (String, String) get clienteRequerido => DialogMessages._mensaje('ventasClienteRequerido');
  (String, String) get camposIncompletos => DialogMessages._mensaje('ventasCamposIncompletos');
  (String, String) get dniRequerido => DialogMessages._mensaje('ventasDniRequerido');
  (String, String) get dniInvalido => DialogMessages._mensaje('ventasDniInvalido');
  (String, String) get nombreClienteRequerido => DialogMessages._mensaje('ventasNombreClienteRequerido');
  (String, String) get noSePudoRegistrarCliente => DialogMessages._mensaje('ventasNoSePudoRegistrarCliente');
  (String, String) get clienteNoEncontrado => DialogMessages._mensaje('ventasClienteNoEncontrado');
  (String, String) get ventaRegistrada => DialogMessages._mensaje('ventasVentaRegistrada');
  (String, String) get noSePudoRegistrarVenta => DialogMessages._mensaje('ventasNoSePudoRegistrarVenta');
  (String, String) get sinProductos => DialogMessages._mensaje('ventasSinProductos');
  (String, String) get ventaNoEncontrada => DialogMessages._mensaje('ventasVentaNoEncontrada');
  (String, String) get montoInvalido => DialogMessages._mensaje('ventasMontoInvalido');
  (String, String) get montoExcedido => DialogMessages._mensaje('ventasMontoExcedido');
  (String, String) get pagoRegistrado => DialogMessages._mensaje('ventasPagoRegistrado');
  (String, String) get noSePudoRegistrarPago => DialogMessages._mensaje('ventasNoSePudoRegistrarPago');
  (String, String) get stockInsuficiente => DialogMessages._mensaje('ventasStockInsuficiente');
  (String, String) get noSePudoGenerarBoleta => DialogMessages._mensaje('ventasNoSePudoGenerarBoleta');
  (String, String) get noSePudoAnularVenta => DialogMessages._mensaje('ventasNoSePudoAnularVenta');
  (String, String) get errorCargarLista => DialogMessages._mensaje('ventasErrorCargarLista');
  (String, String) get errorCargarDetalle => DialogMessages._mensaje('ventasErrorCargarDetalle');
}

class _InventarioMessages {
  (String, String) get camposIncompletos => DialogMessages._mensaje('inventarioCamposIncompletos');
  (String, String) get nombreRequerido => DialogMessages._mensaje('inventarioNombreRequerido');
  (String, String) get precioRequerido => DialogMessages._mensaje('inventarioPrecioRequerido');
  (String, String) get unidadRequerida => DialogMessages._mensaje('inventarioUnidadRequerida');
  (String, String) get stockMinimoInvalido => DialogMessages._mensaje('inventarioStockMinimoInvalido');
  (String, String) get precioInvalido => DialogMessages._mensaje('inventarioPrecioInvalido');
  (String, String) get productoregistrado => DialogMessages._mensaje('inventarioProductoRegistrado');
  (String, String) get noSePudoRegistrarProducto => DialogMessages._mensaje('inventarioNoSePudoRegistrarProducto');
  (String, String) get productoNoEncontrado => DialogMessages._mensaje('inventarioProductoNoEncontrado');
  (String, String) get errorCargarProducto => DialogMessages._mensaje('inventarioErrorCargarProducto');
  (String, String) get noSePudoActualizarProducto => DialogMessages._mensaje('inventarioNoSePudoActualizarProducto');
  (String, String) get noSePudoEliminarProducto => DialogMessages._mensaje('inventarioNoSePudoEliminarProducto');
  (String, String) get noSePudoAgregarLote => DialogMessages._mensaje('inventarioNoSePudoAgregarLote');
  (String, String) get noSePudoEliminarLote => DialogMessages._mensaje('inventarioNoSePudoEliminarLote');
}

class _ClientesMessages {
  (String, String) get sinPagosPendientes => DialogMessages._mensaje('clientesSinPagosPendientes');
  (String, String) get montoInvalido => DialogMessages._mensaje('clientesMontoInvalido');
  (String, String) get montoExcedido => DialogMessages._mensaje('clientesMontoExcedido');
  (String, String) get pagoRegistrado => DialogMessages._mensaje('clientesPagoRegistrado');
  (String, String) get noSePudoRegistrarPago => DialogMessages._mensaje('clientesNoSePudoRegistrarPago');
  (String, String) get errorCargarLista => DialogMessages._mensaje('clientesErrorCargarLista');
}

class _ErrorMessages {
  (String, String) validacion(String mensaje) => DialogMessages._mensajeCon('errorValidacion', mensaje, tag: 'mensaje');
  (String, String) autenticacion(String mensaje) => DialogMessages._mensajeCon('errorAutenticacion', mensaje, tag: 'mensaje');
  (String, String) conexion(String mensaje) => DialogMessages._mensajeCon('errorConexion', mensaje, tag: 'mensaje');
  (String, String) noEncontrado(String mensaje) => DialogMessages._mensajeCon('errorNoEncontrado', mensaje, tag: 'mensaje');
  (String, String) get inesperado => DialogMessages._mensaje('errorInesperado');
  (String, String) get generarPDF => DialogMessages._mensaje('reportesErrorGenerarPDF');
  (String, String) get generarReporte => DialogMessages._mensaje('reportesErrorGenerarReporte');
}

class _ConfigMessages {
  (String, String) get noSePudoCompletarSetup => DialogMessages._mensaje('configNoSePudoCompletarSetup');
  (String, String) get noSePudoGuardar => DialogMessages._mensaje('configNoSePudoGuardar');
}

class _NotificacionesMessages {
  (String, String) get errorCargar => DialogMessages._mensaje('notificacionesErrorCargar');
  (String, String) get errorMarcarLeidas => DialogMessages._mensaje('notificacionesErrorMarcarLeidas');
  (String, String) get errorLimpiar => DialogMessages._mensaje('notificacionesErrorLimpiar');
}
