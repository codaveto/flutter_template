/// Config class to provide usable error message to your [ServiceResponse]'s.
///
/// Provide this config in different languages to easily show feedback to your user when certain
/// actions may have failed.
class FeedbackMessageConfig {
  const FeedbackMessageConfig({
    String? singularForm,
    String? pluralForm,
    this.createFailedTitle = 'Create failed',
    this.createSuccessTitle = 'Create success',
    String singularCreateFailedMessage =
        'Unable to create ${_Forms._singularForm}, please try again later.',
    String singularCreateSuccessMessage = '${_Forms._singularForm} has been created.',
    String pluralCreateFailedMessage =
        'Unable to create ${_Forms._pluralForm}, please try again later.',
    this.searchFailedTitle = 'Search failed',
    this.searchSuccessTitle = 'Search success',
    String singularSearchFailedMessage =
        'Unable to find ${_Forms._singularForm}, please try again later.',
    String pluralSearchFailedMessage =
        'Unable to find ${_Forms._pluralForm}, please try again later.',
    this.updateFailedTitle = 'Update failed',
    String singularUpdateFailedMessage =
        'Unable to update ${_Forms._singularForm}, please try again later.',
    String pluralUpdateFailedMessage =
        'Unable to update ${_Forms._pluralForm}, please try again later.',
    this.deleteFailedTitle = 'Delete failed',
    String singularDeleteFailedMessage =
        'Unable to delete ${_Forms._singularForm}, please try again later.',
    String pluralDeleteFailedMessage =
        'Unable to delete ${_Forms._pluralForm}, please try again later.',
  })  : _singularForm = singularForm,
        _pluralForm = pluralForm,
        _singularCreateFailedMessage = singularCreateFailedMessage,
        _pluralCreateFailedMessage = pluralCreateFailedMessage,
        _singularSearchFailedMessage = singularSearchFailedMessage,
        _pluralSearchFailedMessage = pluralSearchFailedMessage,
        _singularUpdateFailedMessage = singularUpdateFailedMessage,
        _pluralUpdateFailedMessage = pluralUpdateFailedMessage,
        _singularDeleteFailedMessage = singularDeleteFailedMessage,
        _pluralDeleteFailedMessage = pluralDeleteFailedMessage;

  final String? _singularForm;
  final String? _pluralForm;
  final bool _replaceForms;

  final String createFailedTitle;
  final String _singularCreateFailedMessage;
  String get singularCreateFailedMessage =>
      _singularCreateFailedMessage.replaceAll(_Forms._singularForm, _singularForm).capitalize;
  final String _pluralCreateFailedMessage;
  String get pluralCreateFailedMessage =>
      _pluralCreateFailedMessage.replaceAll(_Forms._pluralForm, _pluralForm).capitalize;

  final String searchFailedTitle;
  final String _singularSearchFailedMessage;
  String get singularSearchFailedMessage =>
      _singularSearchFailedMessage.replaceAll(_Forms._singularForm, _singularForm).capitalize;
  final String _pluralSearchFailedMessage;
  String get pluralSearchFailedMessage =>
      _pluralSearchFailedMessage.replaceAll(_Forms._pluralForm, _pluralForm.capitalize).capitalize;

  final String updateFailedTitle;
  final String _singularUpdateFailedMessage;
  String get singularUpdateFailedMessage =>
      _singularUpdateFailedMessage.replaceAll(_Forms._singularForm, _singularForm).capitalize;
  final String _pluralUpdateFailedMessage;
  String get pluralUpdateFailedMessage =>
      _pluralUpdateFailedMessage.replaceAll(_Forms._pluralForm, _pluralForm).capitalize;

  final String deleteFailedTitle;
  final String _singularDeleteFailedMessage;
  String get singularDeleteFailedMessage =>
      _singularDeleteFailedMessage.replaceAll(_Forms._singularForm, _singularForm).capitalize;

  final String _pluralDeleteFailedMessage;
  String get pluralDeleteFailedMessage => (_pluralForm == null
          ? _pluralDeleteFailedMessage
          : _pluralDeleteFailedMessage.replaceAll(_Forms._pluralForm, _pluralForm!))
      .capitalize;
}

abstract class _Forms {
  static const String _singularForm = 'entity';
  static const String _pluralForm = 'entities';
}

extension on String {
  String get capitalize {
    if (isEmpty) {
      return '';
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
