import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:iventi/shared/di/ServiceLocator.dart';

import 'package:iventi/features/auth/pages/WelcomePage.dart';
import 'package:iventi/features/auth/pages/LoginPage.dart';
import 'package:iventi/features/auth/pages/InputEmailPage.dart';
import 'package:iventi/features/auth/pages/CodeEmailPage.dart';
import 'package:iventi/features/auth/pages/CreatePinPage.dart';
import 'package:iventi/features/config/pages/SetupConfigPage.dart';
import 'package:iventi/features/auth/pages/RecoverPinPage.dart';
import 'package:iventi/features/auth/controllers/AuthController.dart';
import 'package:iventi/features/config/controllers/ConfiguracionController.dart';
import 'package:iventi/features/inventory/pages/InventoryPage.dart';
import 'package:iventi/features/inventory/pages/CreateProductPage.dart';
import 'package:iventi/features/inventory/pages/FilterProductsPage.dart';
import 'package:iventi/features/inventory/pages/ProductPage.dart';
import 'package:iventi/features/sales/pages/SalesPage.dart';
import 'package:iventi/features/sales/pages/CreateSalePage.dart';
import 'package:iventi/features/sales/pages/FilterSalesPage.dart';
import 'package:iventi/features/sales/pages/DetailsSalePage.dart';
import 'package:iventi/features/sales/pages/PaymentPage.dart';
import 'package:iventi/features/clients/pages/ClientsPage.dart';
import 'package:iventi/features/clients/pages/FilterClientsPage.dart';
import 'package:iventi/features/clients/pages/DetailsClientPage.dart';
import 'package:iventi/features/notifications/pages/NotificationsPage.dart';
import 'package:iventi/features/config/pages/ConfigPage.dart';
import 'package:iventi/features/reports/pages/ReportsPage.dart';
import 'package:iventi/features/reports/pages/ReportSalesPage.dart';
import 'package:iventi/features/reports/pages/ReportProductosVendidosPage.dart';
import 'package:iventi/features/reports/pages/ReportGeneralInventarioPage.dart';
import 'package:iventi/features/reports/pages/ReportLotesPage.dart';
import 'package:iventi/features/reports/pages/ReportFechaVencimientoPage.dart';
import 'package:iventi/shared/pages/HomePage.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/welcome',
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) async {
      final path = state.matchedLocation;

      if (path == '/welcome') {
        try {
          await ServiceLocator.authController.obtenerUsuarioRegistrado();
          return '/login';
        } catch (_) {
          return null;
        }
      }

      if (path == '/login') {
        try {
          await ServiceLocator.authController.obtenerUsuarioRegistrado();
          return null;
        } catch (_) {
          return '/welcome';
        }
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(key: ValueKey(state.extra)),
        routes: [
          GoRoute(
            path: 'input-email',
            builder: (context, state) => const InputEmailPage(),
          ),
          GoRoute(
            path: 'code-email',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
              return CodeEmailPage(
                correctCode: extra['codigo'] as String,
                emailUser: extra['email'] as String,
                flujo: extra['flujo'] as String? ?? 'register',
              );
            },
          ),
          GoRoute(
            path: 'create-pin',
            builder: (context, state) {
              final extra = state.extra;
              final isRecovery = extra is bool && extra;

              return CreatePinPage(isRecovery: isRecovery);
            },
          ),
          GoRoute(
            path: 'recover-pin',
            builder: (context, state) => const RecoverPinPage(),
          ),
          GoRoute(
            path: 'setup',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};

              return SetupConfigPage(
                email: extra['email'] as String? ?? '',
                pin: extra['pin'] as String? ?? '',
                authController: ServiceLocator.authController,
                configController: ServiceLocator.configuracionController,
              );
            },
          ),
        ],
      ),
      StatefulShellRoute(
        navigatorContainerBuilder: (context, navigationShell, children) {
          return children[navigationShell.currentIndex];
        },
        builder: (context, state, navigationShell) {
          return HomePage(
            key: ValueKey(navigationShell.currentIndex),
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inventory',
                builder: (context, state) => const InventoryPage(),
                routes: [
                  GoRoute(
                    path: 'create-product',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const CreateProductPage(),
                  ),
                  GoRoute(
                    path: 'filter-products',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => FilterProductsPage(
                      filtrosIniciales: state.extra as Map<String, dynamic>?,
                    ),
                  ),
                  GoRoute(
                    path: 'product/:idProducto',
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['idProducto']!);
                      return ProductPage(idProducto: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sales',
                builder: (context, state) => const SalesPage(),
                routes: [
                  GoRoute(
                    path: 'create-sale',
                    builder: (context, state) => const CreateSalePage(),
                    routes: [
                      GoRoute(
                        path: 'payment',
                        builder: (context, state) {
                          final detalles = (state.extra as List<dynamic>?)
                                  ?.cast<Map<String, dynamic>>() ??
                              [];
                          return PaymentPage(detallesVenta: detalles);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'filter-sales',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final f = state.extra as Map<String, dynamic>?;
                      return FilterSalesPage(
                        esAlContado: f?['esAlContado'] as bool?,
                        fechaInicio: f?['fechaInicio'] as DateTime?,
                        fechaFinal: f?['fechaFinal'] as DateTime?,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'details-sale/:idVenta',
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['idVenta']!);
                      return DetailsSalePage(idVenta: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/clients',
                builder: (context, state) => const ClientsPage(),
                routes: [
                  GoRoute(
                    path: 'filter-clients',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      return FilterClientsPage(
                        esDeudorInicial: state.extra as bool?,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'details-client/:idCliente',
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['idCliente']!);
                      return DetailsClientPage(idCliente: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reports',
                builder: (context, state) => const ReportsPage(),
                routes: [
                  GoRoute(path: 'ventas', builder: (context, state) => const ReportSalesPage()),
                  GoRoute(path: 'productos-vendidos', builder: (context, state) => const ReportProductosVendidosPage()),
                  GoRoute(path: 'inventario', builder: (context, state) => const ReportGeneralInventarioPage()),
                  GoRoute(path: 'lotes', builder: (context, state) => const ReportLotesPage()),
                  GoRoute(path: 'vencimientos', builder: (context, state) => const ReportFechaVencimientoPage()),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/config',
                builder: (context, state) => const ConfigPage(),
                routes: [
                  GoRoute(
                    path: 'notifications',
                    builder: (context, state) => const NotificationsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
