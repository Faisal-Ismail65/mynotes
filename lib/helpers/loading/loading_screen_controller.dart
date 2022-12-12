import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = bool Function();

typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingStateController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingStateController({
    required this.close,
    required this.update,
  });
}
