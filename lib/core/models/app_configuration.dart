import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_configuration.freezed.dart';
part 'app_configuration.g.dart';

@freezed
abstract class AppConfiguration with _$AppConfiguration {
  factory AppConfiguration({required AppHint hint}) = _AppConfiguration;

  factory AppConfiguration.fromJson(Map<String, dynamic> json) =>
      _$AppConfigurationFromJson(json);
}

@freezed
abstract class AppHint with _$AppHint {
  factory AppHint({
    @JsonKey(name: 'category_swipe') @Default(false) bool categorySwipeHint,
  }) = _AppHint;

  factory AppHint.fromJson(Map<String, dynamic> json) =>
      _$AppHintFromJson(json);
}
