// ignore_for_file: avoid_positional_boolean_parameters

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/features/core/analytics/custom_analytics.dart';
import 'package:loglytics/loglytics.dart';

import '../../../strings/generated/l10n.dart';

abstract class BaseViewModel<T extends CustomAnalytics> with Loglytics<T> {
  final ValueNotifier<bool> _isInitialised = ValueNotifier(false);
  ValueListenable<bool> get isInitialised => _isInitialised;

  final ValueNotifier<bool> _isBusy = ValueNotifier(false);
  ValueListenable<bool> get isBusy => _isBusy;

  final ValueNotifier<bool> _hasError = ValueNotifier(false);
  ValueListenable<bool> get hasError => _hasError;

  String? _errorMessage;
  String get errorMessage =>
      _errorMessage ?? Strings.current.somethingWentWrong;

  final Strings strings = Strings.current;

  late final DisposableBuildContext _disposableBuildContext;
  BuildContext get context => _disposableBuildContext.context!;

  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  @mustCallSuper
  void initialise(DisposableBuildContext context) {
    _disposableBuildContext = context;
    _isInitialised.value = true;
    log.mvvm('I am initialised!');
  }

  void setBusy(bool isBusy) {
    _isBusy.value = isBusy;
  }

  void setError(bool hasError, {String? message}) {
    _errorMessage = hasError ? message : null;
    _hasError.value = hasError;
  }

  void dispose() {
    _disposableBuildContext.dispose();
    log.mvvm('I am disposed!');
  }
}
