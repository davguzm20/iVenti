import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),

              Image.asset('lib/assets/iconos/iconoApp.png', height: 180),

              const SizedBox(height: 40),

              const Text(
                'Bienvenido a iVenti',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Sistema de gestión de inventario y ventas',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textLight),
              ),

              const SizedBox(height: 60),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyles.success(),
                  onPressed: () => context.push('/login/input-email', extra: 'register'),
                  child: const Text('¿Eres nuevo? Regístrate aquí',
                      style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyles.primary(),
                  onPressed: () => context.push('/login/input-email', extra: 'verify'),
                  child: const Text('Ya tengo cuenta', style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
