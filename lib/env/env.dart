// lib/env/env.dart
import 'package:envied/envied.dart';
import 'package:fl_app/ads/call_ads.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'KEY')
  static String key = _Env.key;
}
