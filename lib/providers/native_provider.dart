import 'package:flutter/services.dart';
import 'package:labyrinth/utils/constants.dart';

class NativeProvider {
  // ignore: non_constant_identifier_names
  static var platform_apple_sign =
      const MethodChannel('$kPackageName/apple_sign');

  static Future<String> initAppleSign() async {
    print('[APPLE] init');
    final result = await platform_apple_sign.invokeMethod('init', '');
    print('[APPLE] response:' + String.fromCharCodes(result));
    return String.fromCharCodes(result);
  }
}
