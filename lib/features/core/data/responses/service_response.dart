import '../enums/feedback_type.dart';
import '../enums/notification_level.dart';

class ServiceResponse<T extends Object?> {
  ServiceResponse._({
    required this.notificationLevel,
    required this.feedbackType,
    this.title,
    this.message,
    this.result,
  });

  final NotificationLevel notificationLevel;
  final FeedbackType feedbackType;
  final String? title;
  final String? message;
  final T? result;

  factory ServiceResponse.success({
    String? title,
    String? message,
    T? result,
    NotificationLevel notificationLevel = NotificationLevel.success,
    FeedbackType feedbackType = FeedbackType.snackbar,
  }) =>
      ServiceResponse._(
        notificationLevel: notificationLevel,
        title: title,
        message: message,
        feedbackType: feedbackType,
        result: result,
      );

  factory ServiceResponse.error({
    String? title,
    String? message,
    NotificationLevel notificationLevel = NotificationLevel.error,
    FeedbackType feedbackType = FeedbackType.dialog,
  }) =>
      ServiceResponse._(
        notificationLevel: notificationLevel,
        title: title,
        message: message,
        feedbackType: feedbackType,
      );

  bool get isSuccess => notificationLevel == NotificationLevel.success;
  E resultAsCast<E>() => result as E;
  bool get hasValidMessage =>
      (title != null && title!.isNotEmpty) && (message != null && message!.isNotEmpty);

  ServiceResponse copyWith({
    NotificationLevel? notificationLevel,
    FeedbackType? feedbackType,
    String? title,
    String? message,
  }) {
    if (isSuccess) {
      return ServiceResponse.success(
        notificationLevel: notificationLevel ?? this.notificationLevel,
        feedbackType: feedbackType ?? this.feedbackType,
        title: title ?? this.title,
        message: message ?? this.message,
        result: result,
      );
    }
    return ServiceResponse.error(
      notificationLevel: notificationLevel ?? this.notificationLevel,
      feedbackType: feedbackType ?? this.feedbackType,
      title: title ?? this.title,
      message: message ?? this.message,
    );
  }
}
