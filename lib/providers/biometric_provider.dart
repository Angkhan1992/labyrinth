import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:labyrinth/providers/shared_provider.dart';
import 'package:local_auth/local_auth.dart';

class BiometricProvider {
  LocalAuthentication? auth;
  List<BiometricType>? _availableBiometrics;
  bool? _canCheckBiometrics;

  BiometricProvider();

  factory BiometricProvider.of({Function()? init}) {
    return BiometricProvider()..init(init: init);
  }

  Future<void> init({
    Function()? init,
  }) async {
    auth = LocalAuthentication();
    await _checkBiometrics();
    await _getAvailableBiometrics();
    init!();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth!.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      if (kDebugMode) {
        print(e);
      }
    }
    if (kDebugMode) {
      print('[Local Auth] canCheckBiometrics $canCheckBiometrics');
    }
    _canCheckBiometrics = canCheckBiometrics;
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth!.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      if (kDebugMode) {
        print(e);
      }
    }
    if (kDebugMode) {
      print('[Local Auth] availableBiometrics $availableBiometrics');
    }
    _availableBiometrics = availableBiometrics;
  }

  bool isEnabled() => _canCheckBiometrics!;

  BiometricType? availableType() {
    if (_availableBiometrics!.contains(BiometricType.face)) {
      return BiometricType.face;
    }
    if (_availableBiometrics!.contains(BiometricType.fingerprint)) {
      return BiometricType.fingerprint;
    }
    return null;
  }

  Future<bool?> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth!.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('[Local Auth] error ${e.message}');
      }
      return null;
    }

    if (kDebugMode) {
      print('[Local Auth] auth : $authenticated');
    }
    return authenticated;
  }

  Future<LocalAuthState> getState() async {
    if (!_canCheckBiometrics!) return LocalAuthState.unsupport;
    if (availableType() == null) return LocalAuthState.unsupport;
    var enabled = await SharedProvider().isBioEnabled();
    if (!enabled) return LocalAuthState.disable;
    var isBioAuth = await SharedProvider().isBioAuth();
    if (isBioAuth == null) return LocalAuthState.none;
    return isBioAuth ? LocalAuthState.auth : LocalAuthState.noauth;
  }
}

enum LocalAuthState {
  none,
  disable,
  auth,
  noauth,
  unsupport,
}
