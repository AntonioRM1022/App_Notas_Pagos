import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) return true; // Dejar pasar o pedir PIN si no hay soporte

      return await auth.authenticate(
        localizedReason: 'Por favor, autentícate para acceder a tu información',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (e) {
      return false;
    }
  }
}
