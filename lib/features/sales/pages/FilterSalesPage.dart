import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';

class FilterSalesPage extends StatefulWidget {
  static DateTime? testFechaFija;

  final bool? esAlContado;
  final DateTime? fechaInicio;
  final DateTime? fechaFinal;

  const FilterSalesPage({super.key, this.esAlContado, this.fechaInicio, this.fechaFinal});

  @override
  State<FilterSalesPage> createState() => _FilterSalesState();
}

class _FilterSalesState extends State<FilterSalesPage> {
  bool? esAlContado;
  bool habilitarFiltroPago = false;
  bool habilitarFiltroFecha = false;
  DateTime? fechaInicio;
  DateTime? fechaFinal;
  TextEditingController fechaInicioController = TextEditingController();
  TextEditingController fechaFinalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    esAlContado = widget.esAlContado;
    fechaInicio = widget.fechaInicio;
    fechaFinal = widget.fechaFinal;
    fechaInicioController.text = fechaInicio != null ? formatoFecha(fechaInicio!) : '';
    fechaFinalController.text = fechaFinal != null ? formatoFecha(fechaFinal!) : '';
    habilitarFiltroPago = esAlContado != null;
    habilitarFiltroFecha = fechaInicio != null || fechaFinal != null;
  }

  void aplicarFiltros() => context.pop({
    'esAlContado': habilitarFiltroPago ? esAlContado : null,
    'fechaInicio': habilitarFiltroFecha ? fechaInicio : null,
    'fechaFinal': habilitarFiltroFecha ? fechaFinal : null,
  });

  String formatoFecha(DateTime fecha) =>
      "${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}";

  Future<void> seleccionarFecha(bool esInicio) async {
    final picked = FilterSalesPage.testFechaFija ?? await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        if (esInicio) { fechaInicio = picked; fechaInicioController.text = formatoFecha(picked); }
        else { fechaFinal = picked; fechaFinalController.text = formatoFecha(picked); }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filtros de Ventas", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      title: const Text("Filtrar por Tipo de Pago", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      subtitle: const Text("Activa esta opción para filtrar por tipo de pago."),
                      value: habilitarFiltroPago, activeThumbColor: AppColors.success,
                      onChanged: (value) => setState(() { habilitarFiltroPago = value; esAlContado = value ? esAlContado : null; }),
                    ),
                    if (habilitarFiltroPago) ...[
                      const Divider(),
                      const Text("Selecciona tipo de pago:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => setState(() => esAlContado = true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: esAlContado == true ? AppColors.success : Colors.grey[300],
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: Text("Al contado", style: TextStyle(color: esAlContado == true ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () => setState(() => esAlContado = false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: esAlContado == false ? AppColors.success : Colors.grey[300],
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: Text("Crédito", style: TextStyle(color: esAlContado == false ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      title: const Text("Filtrar por Rango de Fechas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      subtitle: const Text("Activa esta opción para filtrar por rango de fechas."),
                      value: habilitarFiltroFecha, activeThumbColor: AppColors.success,
                      onChanged: (value) => setState(() {
                        habilitarFiltroFecha = value;
                        if (!value) { fechaInicioController.clear(); fechaFinalController.clear(); fechaInicio = null; fechaFinal = null; }
                      }),
                    ),
                    if (habilitarFiltroFecha) ...[
                      const SizedBox(height: 10),
                      TextField(
                        controller: fechaInicioController,
                        decoration: InputDecoration(
                          labelText: 'Fecha Inicio',
                          suffixIcon: fechaInicio != null
                              ? IconButton(icon: const Icon(Icons.clear, color: Colors.red), onPressed: () => setState(() { fechaInicio = null; fechaInicioController.clear(); }))
                              : const Icon(Icons.calendar_today, color: AppColors.primary),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        readOnly: true, onTap: () => seleccionarFecha(true),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: fechaFinalController,
                        decoration: InputDecoration(
                          labelText: 'Fecha Final',
                          suffixIcon: fechaFinal != null
                              ? IconButton(icon: const Icon(Icons.clear, color: Colors.red), onPressed: () => setState(() { fechaFinal = null; fechaFinalController.clear(); }))
                              : const Icon(Icons.calendar_today, color: AppColors.primary),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        readOnly: true, onTap: () => seleccionarFecha(false),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                  style: ButtonStyles.primary(),
                icon: const Icon(Icons.filter_alt),
                label: const Text("Aplicar Filtros", style: TextStyle(fontSize: 18)),
                onPressed: aplicarFiltros,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
