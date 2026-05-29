import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sosRed,
      body: const SafeArea(
        child: Center(
          child: Text(
            'SOS Screen - Coming Soon',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
