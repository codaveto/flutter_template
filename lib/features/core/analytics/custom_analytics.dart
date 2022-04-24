import 'package:loglytics/loglytics.dart';

/// Used to provide a default interface for MedApp analytics logging.
abstract class CustomAnalytics extends Analytics {
  final _Parameters parameters = const _Parameters();
  final _Subjects subjects = const _Subjects();

  ///
  void buttonClicked({
    required String text,
    required String location,
  }) =>
      service.clicked(
        subject: subjects.button,
        parameters: {
          parameters.text: text,
          parameters.location: location,
        },
      );
}

/// Used to provide commonly used (and consciously chosen) parameters.
class _Parameters {
  const _Parameters();
  String get id => _id;
  static const _id = 'id';

  String get ids => _ids;
  static const _ids = 'ids';

  String get location => _location;
  static const _location = 'location';

  String get text => _text;
  static const _text = 'text';

  String get type => _type;
  static const _type = 'type';

  String get value => _value;
  static const _value = 'value';

  String get previousValue => _previousValue;
  static const _previousValue = 'previous_value';
}

/// Used to provide commonly used (and consciously chosen) subjects.
class _Subjects {
  const _Subjects();
  String get button => _button;
  static const String _button = 'button';
}
