import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_template/features/core/util/app_setup.dart';
import 'package:get_it/get_it.dart';

import '../abstracts/base_view_model.dart';

class StartupViewModel extends BaseViewModel {
  StartupViewModel();

  @override
  Future<void> initialise(DisposableBuildContext context) async {
    AppSetup.initialise(context: context.context!);
    super.initialise(context);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  static StartupViewModel get locate => GetIt.instance.get();
}
