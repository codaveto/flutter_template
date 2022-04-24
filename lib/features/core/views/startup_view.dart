import 'package:flutter/material.dart';

import '../widgets/view_model_builder.dart';
import 'startup_view_model.dart';

class StartupView extends StatelessWidget {
  const StartupView({Key? key}) : super(key: key);
  static const String route = '/startup-view';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupViewModel>(
      builder: (context, model) => const Scaffold(),
      viewModelBuilder: () => StartupViewModel.locate,
    );
  }
}
