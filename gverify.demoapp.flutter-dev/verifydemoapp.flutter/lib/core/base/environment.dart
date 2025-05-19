
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvironmentType {dev, pro}
abstract class Environment{

  static late EnvironmentType _environmentType;
  static EnvironmentType get environmentType => _environmentType;
  static setupEnv(EnvironmentType env) async {
    _environmentType = env;
    switch (env){
      case EnvironmentType.dev:
        {
          await dotenv.load(fileName:'.env.dev');
          break;
        }
      case EnvironmentType.pro:
        {
          await dotenv.load(fileName: '.env.production');
          break;
        }
    }

  }
  static String get fileName {
    if (kReleaseMode){
      return '.env.production';
    }
    return '.env.dev';
  }
  static String get apiUrl{
    return dotenv.env['API_URL'] ?? '';
  }
}