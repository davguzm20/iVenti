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

  static (String, String) _mensajeCon(String key, String parametro) {
    final titulo = _cache?['${key}Titulo'] ?? '[$key]';
    final descripcion = (_cache?['${key}Descripcion'] ?? '').replaceAll('{email}', parametro);
    return (titulo, descripcion);
  }

  static final auth = _AuthMessages();
  static final ventas = _VentasMessages();
  static final inventario = _InventarioMessages();
  static final clientes = _ClientesMessages();
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
}

class _VentasMessages {
  (String, String) get montoInsuficiente => DialogMessages._mensaje('ventasMontoInsuficiente');
  (String, String) get clienteRequerido => DialogMessages._mensaje('ventasClienteRequerido');
  (String, String) get camposIncompletos => DialogMessages._mensaje('ventasCamposIncompletos');
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
}

class _InventarioMessages {
  (String, String) get camposIncompletos => DialogMessages._mensaje('inventarioCamposIncompletos');
  (String, String) get stockMinimoInvalido => DialogMessages._mensaje('inventarioStockMinimoInvalido');
  (String, String) get precioInvalido => DialogMessages._mensaje('inventarioPrecioInvalido');
  (String, String) get productoregistrado => DialogMessages._mensaje('inventarioProductoRegistrado');
  (String, String) get noSePudoRegistrarProducto => DialogMessages._mensaje('inventarioNoSePudoRegistrarProducto');
  (String, String) get productoNoEncontrado => DialogMessages._mensaje('inventarioProductoNoEncontrado');
}

class _ClientesMessages {
  (String, String) get sinPagosPendientes => DialogMessages._mensaje('clientesSinPagosPendientes');
  (String, String) get montoInvalido => DialogMessages._mensaje('clientesMontoInvalido');
  (String, String) get montoExcedido => DialogMessages._mensaje('clientesMontoExcedido');
  (String, String) get pagoRegistrado => DialogMessages._mensaje('clientesPagoRegistrado');
  (String, String) get noSePudoRegistrarPago => DialogMessages._mensaje('clientesNoSePudoRegistrarPago');
}
