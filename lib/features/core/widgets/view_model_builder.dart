import 'package:flutter/widgets.dart';

import '../abstracts/base_view_model.dart';

class ViewModelBuilder<T extends BaseViewModel> extends StatefulWidget {
  const ViewModelBuilder({
    required Widget Function(BuildContext context, T model) builder,
    required T Function() viewModelBuilder,
    Key? key,
  })  : _builder = builder,
        _viewModelBuilder = viewModelBuilder,
        super(key: key);

  final Widget Function(BuildContext context, T model) _builder;
  final T Function() _viewModelBuilder;

  @override
  _ViewModelBuilderState<T> createState() => _ViewModelBuilderState<T>();
}

class _ViewModelBuilderState<T extends BaseViewModel>
    extends State<ViewModelBuilder<T>> {
  late final T _viewModel;

  @override
  void initState() {
    _viewModel = widget._viewModelBuilder();
    _viewModel.initialise(DisposableBuildContext(this));
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget._builder(context, _viewModel);
}
