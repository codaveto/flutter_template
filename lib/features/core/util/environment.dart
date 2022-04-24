enum EnvironmentType {
  dev,
  prod,
}

abstract class Environment {
  static const String _dev = 'dev';
  static const String _prod = 'prod';

  static const argumentKey = 'env';
  static const fileName = '.env';

  static EnvironmentType get current {
    switch (const String.fromEnvironment(
      Environment.argumentKey,
      defaultValue: _prod,
    )) {
      case _dev:
        return EnvironmentType.dev;
      case _prod:
      default:
        return EnvironmentType.prod;
    }
  }

  static bool get isDev => current == EnvironmentType.dev;
  static bool get isProd => current == EnvironmentType.prod;
}
