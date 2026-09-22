import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/security/biometric_auth_service.dart';
import 'package:go_router/go_router.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final BiometricAuthService _authService = BiometricAuthService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _authenticate();
  }

  Future<void> _authenticate() async {
    final success = await _authService.authenticate();
    if (success && mounted) {
      context.go('/dashboard');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D121C), // Even darker for lock screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pulse animation for fingerprint
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1E2D4A).withOpacity(0.3 + (0.7 * (1 - _controller.value))),
                      width: 2 + (20 * _controller.value),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF162137),
                      ),
                      child: const Icon(
                        Icons.fingerprint,
                        size: 50,
                        color: Color(0xFF3B5998), // Blueish fingerprint
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 60),
            const Text(
              'Verificando Identidad',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'para acceder a la bóveda local',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF8E9BB0),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '...',
              style: TextStyle(
                fontSize: 30,
                color: Color(0xFF8E9BB0),
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
