import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_state.freezed.dart';

@freezed
sealed class ActionState with _$ActionState {
  const factory ActionState.initial() = _ActionInitial;
  const factory ActionState.loading() = _ActionLoading;
  const factory ActionState.success({required String message}) = _ActionSuccess;
  const factory ActionState.error({required String message}) = _ActionError;
}
