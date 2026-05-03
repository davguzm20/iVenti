import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilterProductsPage extends StatefulWidget {
  final Map<String, dynamic>? filtrosIniciales;

  const FilterProductsPage({super.key, this.filtrosIniciales});

  @override
  State<FilterProductsPage> createState() => _FilterProductsPageState();
}

class _FilterProductsPageState extends State<FilterProductsPage> {
  bool? stockBajo;

  @override
  void initState() {
    super.initState();
    stockBajo = widget.filtrosIniciales?['stockBajo'] as bool?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filtrar productos")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Stock",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                _buildChip("Todos", stockBajo == null, () => setState(() => stockBajo = null)),
                _buildChip("Stock bajo", stockBajo == true, () => setState(() => stockBajo = true)),
                _buildChip("Stock normal", stockBajo == false, () => setState(() => stockBajo = false)),
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
                onPressed: () => context.pop({'stockBajo': stockBajo}),
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
