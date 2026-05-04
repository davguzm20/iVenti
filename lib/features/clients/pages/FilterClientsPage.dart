import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';

class FilterClientsPage extends StatefulWidget {
  final bool? esDeudorInicial;

  const FilterClientsPage({super.key, this.esDeudorInicial});

  @override
  State<FilterClientsPage> createState() => _FilterClientsPageState();
}

class _FilterClientsPageState extends State<FilterClientsPage> {
  bool? esDeudor;
  bool habilitarFiltro = false;

  @override
  void initState() {
    super.initState();
    esDeudor = widget.esDeudorInicial;
    habilitarFiltro = esDeudor != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filtrar clientes")),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        title: const Text("Filtrar por Estado", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: const Text("Activa esta opción para filtrar clientes por su estado de deuda.", style: TextStyle(color: Colors.black54)),
                        value: habilitarFiltro,
                        activeColor: AppColors.success,
                        onChanged: (value) {
                          setState(() {
                            habilitarFiltro = value;
                            esDeudor = value ? true : null;
                          });
                        },
                      ),
                      if (habilitarFiltro)
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            const Text("¿Qué clientes quieres ver?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () => setState(() => esDeudor = true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: esDeudor == true ? Colors.red : Colors.grey[300],
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  ),
                                  child: Text("Deudores", style: TextStyle(color: esDeudor == true ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton(
                                  onPressed: () => setState(() => esDeudor = false),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: esDeudor == false ? AppColors.success : Colors.grey[300],
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  ),
                                  child: Text("Regulares", style: TextStyle(color: esDeudor == false ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  backgroundColor: AppColors.primary,
                ),
                icon: const Icon(Icons.filter_alt, color: Colors.white),
                label: const Text("Aplicar Filtros", style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: () => context.pop(esDeudor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
