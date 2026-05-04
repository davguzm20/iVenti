import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/clients/entities/ClienteEntity.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/features/clients/controllers/ClienteController.dart';
import 'package:iventi/shared/config/AppColors.dart';
import 'package:iventi/shared/config/ButtonStyles.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Timer? _searchTimer;

  List<ClienteEntity> clientes = [];
  String nombreBuscado = "";
  bool? esDeudor;
  bool isSearching = false;
  bool isLoading = false;

  ClienteController get _clienteController => ServiceLocator.clienteController;

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  Future<void> _cargarClientes({bool reiniciar = false}) async {
    if (isLoading) return;

    if (reiniciar) {
      setState(() => clientes.clear());
    }

    setState(() => isLoading = true);

    final nuevos = await _clienteController.obtenerFiltrados(
      limite: 50,
      offset: 0,
      esDeudor: esDeudor,
    );

    if (mounted) {
      setState(() {
        if (reiniciar) {
          clientes = nuevos;

        } else {
          clientes.addAll(nuevos);
        }

        isLoading = false;
      });
    }
  }

  void _buscarClientesPorNombre(String nombre) {
    if (_searchTimer?.isActive ?? false) {
      _searchTimer!.cancel();
    }

    _searchTimer = Timer(const Duration(milliseconds: 300), () async {
      if (nombre.isEmpty) {
        _cargarClientes(reiniciar: true);
        return;
      }

      final filtrados = await _clienteController.buscarPorNombre(nombre);

      setState(() => clientes = filtrados);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: isSearching ? MediaQuery.of(context).size.width - 32 : 150,
          child: isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Buscar cliente...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();

                        setState(() {
                          isSearching = false;
                          nombreBuscado = "";
                        });

                        _cargarClientes(reiniciar: true);
                      },
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                  ),
                  onChanged: (value) {
                    setState(() => nombreBuscado = value);
                    _buscarClientesPorNombre(value);
                  },
                )
              : const Text(
                  "Mis clientes",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
        ),
        actions: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSearching ? 0 : 48,
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() => isSearching = true);
              },
            ),
          ),

          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () async {
                final filtro =
                    await context.push<bool?>('/clients/filter-clients',
                        extra: esDeudor);

                setState(() => esDeudor = filtro);

                _cargarClientes(reiniciar: true);
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: clientes.isEmpty
                ? const Center(
                    child: Text(
                      "No se encontraron clientes",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: clientes.length,
                    itemBuilder: (context, index) {
                      final cliente = clientes[index];

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primary, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${cliente.nombres} ${cliente.apellidos}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: AppColors.primary,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      "Email: ${cliente.email ?? "---"}",
                                      style: const TextStyle(
                                          color: Colors.black),
                                    ),

                                    Text(
                                      "Teléfono: ${cliente.telefono ?? "---"}",
                                      style: const TextStyle(
                                          color: Colors.black),
                                    ),

                                    Text(
                                      "Estado: ${cliente.esDeudor ? "Deudor" : "Regular"}",
                                      style: TextStyle(
                                        color: cliente.esDeudor
                                            ? Colors.red
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyles.success(),
                                    onPressed: () async {
                                      await context.push(
                                          '/clients/details-client/${cliente.idCliente}');

                                      _cargarClientes(reiniciar: true);
                                    },
                                    child: const Text("Detalles"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 6,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
