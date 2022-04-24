import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/features/core/data/enums/supported_language.dart';
import 'package:flutter_template/features/core/views/startup_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:loglytics/loglytics.dart';

import '../../../strings/generated/l10n.dart';

abstract class AppSetup {
  static Future<void> initialise({required BuildContext context}) async {
    final log = Log(location: 'AppSetup');
    WidgetsFlutterBinding.ensureInitialized();
    log.info('Initialising firebase app..');
    await Firebase.initializeApp();
    log.success('Firebase app initialized!');
    _setupLocator(log: log);
    await _setupLoglytics(log: log);
    _setupStrings(context, log);
    log.success('App initialized!');
  }

  static void _setupStrings(BuildContext context, Log log) {
    log.info('Setting up strings..');
    final currentLocale = Localizations.localeOf(context);
    log.value(currentLocale, 'User locale');
    final supportedLocale = currentLocale.toSupportedLocaleWithDefault;
    log.value(supportedLocale, 'Using locale');
    Strings.load(supportedLocale);
    log.success('Strings loaded!');
  }

  static void _setupLocator({required Log log}) {
    final locator = GetIt.instance;
    void _setupFactories() {
      log.info('Setting up factories..');
      locator.registerFactory(() => StartupViewModel());
      log.success('Factories set up!');
    }

    void _setupLazySingletons() {
      log.info('Setting up lazy singletons..');
      log.success('Lazy singletons set up!');
    }

    void _setupSingletons() {
      log.info('Setting up singletons..');
      log.success('Singleton set up!');
    }

    _setupFactories();
    _setupLazySingletons();
    _setupSingletons();
  }

  static Future<void> _setupLoglytics({required Log log}) async {
    log.info('Setting up Loglytics..');
    // Loglytics.setUp(
    //   analyticsInterface: AnalyticsImplementation(),
    //   crashReportsInterface: CrashReportsImplementation(FirebaseCrashlytics.instance),
    //   analytics: (analyticsFactory) {
    //   },
    // );
    log.success('Loglytics set up!');
  }

  static Future<void> reset() async {
    final log = Log(location: 'AppSetup');
    log.info('Resetting app..');
    log.info('Resetting locator..');
    await GetIt.instance.reset();
    log.success('Locator reset!');
    if (Loglytics.isActive) {
      log.info('Loglytics is active, resetting Loglytics..');
      await Loglytics.dispose();
      log.success('Loglytics reset!');
    }
    _setupLocator(log: log);
    _setupLoglytics(log: log);
    log.success('App reset!');
  }

  static void Function(Object error, StackTrace stackTrace) get onUncaughtException =>
      (error, stackTrace) => Log(location: 'Zoned').error(
            'Unhandled exception caught: ${error.toString()}',
            error: error,
            stackTrace: stackTrace,
          );
}
