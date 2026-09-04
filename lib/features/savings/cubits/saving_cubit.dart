import 'package:bloc/bloc.dart';
import 'package:dompet_app/features/savings/enums/saving_status.dart';
import 'package:dompet_app/features/savings/models/saving_filter.dart';
import 'package:dompet_app/features/savings/models/saving_plan.dart';
import 'package:dompet_app/features/savings/repositories/saving_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'saving_cubit.freezed.dart';

@freezed
sealed class SavingState with _$SavingState {
  const factory SavingState.initial() = _SavingInitial;
  const factory SavingState.loading() = _SavingLoading;
  const factory SavingState.refreshing({@Default([]) List<SavingPlan> plans}) =
      _SavingRefreshing;
  const factory SavingState.loaded({@Default([]) List<SavingPlan> plans}) =
      _SavingLoaded;
  const factory SavingState.error({required String message}) = _SavingError;
}

class SavingCubit extends Cubit<SavingState> {
  final SavingRepository _repository;
  SavingCubit(this._repository) : super(const SavingState.initial());

  String? _lastKeyword;
  String _lastStatus = 'ACTIVE';

  Future<void> fetch({String? keyword, String? status}) async {
    _lastKeyword = keyword;
    if (status != null) _lastStatus = status;

    emit(const SavingState.loading());
    await _loadPlans(keyword: _lastKeyword, status: _lastStatus);
  }

  Future<void> refresh() async {
    final currentPlans = state.maybeWhen(
      loaded: (plans) => plans,
      orElse: () => <SavingPlan>[],
    );

    emit(SavingState.refreshing(plans: currentPlans));
    await _loadPlans(keyword: _lastKeyword, status: _lastStatus);
  }

  Future<void> _loadPlans({String? keyword, String? status}) async {
    final filter = SavingFilter(
      accountName: keyword,
      status: status ?? SavingStatus.active.value,
    );

    try {
      final plans = await _repository.getPockets(filter);
      emit(SavingState.loaded(plans: plans));
    } catch (e) {
      emit(SavingState.error(message: e.toString()));
    }
  }
}
