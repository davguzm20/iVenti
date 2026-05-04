import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 4, left: 4),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 28),
            color: Colors.black87,
            onPressed: () => context.pop(),
          ),
        ),
      ),
    );
  }
}
