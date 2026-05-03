import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilterClientsPage extends StatefulWidget {
  final bool? esDeudorInicial;

  const FilterClientsPage({super.key, this.esDeudorInicial});

  @override
  State<FilterClientsPage> createState() => _FilterClientsPageState();
}

class _FilterClientsPageState extends State<FilterClientsPage> {
  bool? esDeudor;

  @override
  void initState() {
    super.initState();
    esDeudor = widget.esDeudorInicial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filtrar clientes")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Estado",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                _buildChip("Todos", esDeudor == null, () => setState(() => esDeudor = null)),
                _buildChip("Deudores", esDeudor == true, () => setState(() => esDeudor = true)),
                _buildChip("Regulares", esDeudor == false, () => setState(() => esDeudor = false)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2BBF55),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => context.pop(esDeudor),
                child: const Text("Aplicar filtros", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool selected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      selectedColor: const Color(0xFF493D9E),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: selected ? Colors.white : const Color(0xFF493D9E),
      ),
      onSelected: (_) => onTap(),
    );
  }
}
