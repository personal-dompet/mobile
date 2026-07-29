import 'package:bloc/bloc.dart';
import 'package:dompet_app/features/journals/models/journal_entry.dart';
import 'package:dompet_app/features/journals/repositories/journal_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_detail_cubit.freezed.dart';

@freezed
sealed class ActivityDetailState with _$ActivityDetailState {
  const factory ActivityDetailState.initial() = _ActivityDetailInitial;
  const factory ActivityDetailState.loading() = _ActivityDetailLoading;
  const factory ActivityDetailState.actionLoading({JournalEntry? activity}) =
      _ActivityDetailActionLoading;
  const factory ActivityDetailState.loaded({required JournalEntry activity}) =
      _ActivityDetailLoaded;
  const factory ActivityDetailState.actionSuccess({JournalEntry? activity}) =
      _ActivityDetailActionSuccess;
  const factory ActivityDetailState.error({required String message}) =
      _ActivityDetailError;
  const factory ActivityDetailState.actionError({
    JournalEntry? activity,
    required String message,
  }) = _ActivityDetailActionError;
}

class ActivityDetailCubit extends Cubit<ActivityDetailState> {
  final JournalRepository _repository;

  ActivityDetailCubit(this._repository)
    : super(const ActivityDetailState.initial());

  Future<void> init(int id) async {
    emit(ActivityDetailState.loading());

    try {
      final activity = await _repository.getJournal(id);
      emit(ActivityDetailState.loaded(activity: activity));
    } catch (e) {
      emit(ActivityDetailState.error(message: e.toString()));
    }
  }

  Future<void> deleteActivity(int id) async {
    final activity = state.maybeWhen(
      orElse: () => null,
      loaded: (activity) => activity,
      actionLoading: (activity) => activity,
      actionSuccess: (activity) => activity,
      actionError: (activity, _) => activity,
    );
    emit(ActivityDetailState.actionLoading(activity: activity));

    try {
      await _repository.deleteJournal(id);
      emit(ActivityDetailState.actionSuccess(activity: activity));
    } catch (e) {
      emit(ActivityDetailState.actionError(message: e.toString()));
    }
  }
}
