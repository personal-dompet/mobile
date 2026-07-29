// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppConfiguration _$AppConfigurationFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_AppConfiguration', json, ($checkedConvert) {
      final val = _AppConfiguration(
        hint: $checkedConvert(
          'hint',
          (v) => AppHint.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AppConfigurationToJson(_AppConfiguration instance) =>
    <String, dynamic>{'hint': instance.hint};

_AppHint _$AppHintFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_AppHint', json, ($checkedConvert) {
      final val = _AppHint(
        categorySwipeHint: $checkedConvert(
          'category_swipe',
          (v) => v as bool? ?? false,
        ),
      );
      return val;
    }, fieldKeyMap: const {'categorySwipeHint': 'category_swipe'});

Map<String, dynamic> _$AppHintToJson(_AppHint instance) => <String, dynamic>{
  'category_swipe': instance.categorySwipeHint,
};
