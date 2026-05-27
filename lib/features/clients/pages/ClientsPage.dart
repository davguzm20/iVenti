import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/clients/entities/ClienteEntity.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/features/clients/controllers/ClienteController.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/features/clients/widgets/ClientCard.dart';

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
  int cantidadCargas = 0;
  bool hayMasCargas = true;
  bool isSearching = false;
  bool isLoading = false;

  ClienteController get _clienteController => ServiceLocator.clienteController;

  @override
  void initState() {
    super.initState();
    _cargarClientes();
    _scrollController.addListener(_detectarScrollFinal);
  }

  void _detectarScrollFinal() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        hayMasCargas &&
        nombreBuscado.isEmpty) {
      _cargarClientes();
    }
  }

  Future<void> _cargarClientes({bool reiniciar = false}) async {
    if (!hayMasCargas && !reiniciar) return;
    if (isLoading) return;

    if (reiniciar) {
      setState(() { clientes.clear(); cantidadCargas = 0; hayMasCargas = true; });
    }

    setState(() => isLoading = true);

    final nuevos = await _clienteController.obtenerFiltrados(
      limite: 50,
      offset: cantidadCargas * 50,
      esDeudor: esDeudor,
    );

    if (mounted) {
      setState(() {
        if (reiniciar) {
          clientes = nuevos;
        } else {
          clientes.addAll(nuevos);
        }
        if (nuevos.isNotEmpty) {
          cantidadCargas++;
        } else {
          hayMasCargas = false;
        }
        isLoading = false;
      });
    }
  }

  void _buscarClientesPorNombre(String nombre) {
    if (_searchTimer?.isActive ?? false) _searchTimer!.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 300), () async {
      if (nombre.isEmpty) { _cargarClientes(reiniciar: true); return; }
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
                    fillColor: Colors.white.withValues(alpha: 0.2),
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

                      return ClientCard(
                        client: cliente,
                        onViewDetail: () async {
                          await context.push('/clients/details-client/${cliente.idCliente}');
                          _cargarClientes(reiniciar: true);
                        },
                      );
                    },
                  ),
          ),

          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
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
