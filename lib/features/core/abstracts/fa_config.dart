import 'package:flutter_template/features/core/abstracts/fa_message_config.dart';

class FaConfig {
  const FaConfig({
    required this.collectionPath,
    this.faMessageConfig = const FeedbackMessageConfig(),
  });

  final String collectionPath;
  final FeedbackMessageConfig faMessageConfig;
}
