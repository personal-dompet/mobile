import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/accounts/model/account.dart';
import 'package:dompet_app/features/accounts/model/account_filter.dart';
import 'package:dompet_app/features/accounts/repositories/account_repository.dart';
import 'package:dompet_app/features/transactions/enums/transaction_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_cubit.freezed.dart';

@freezed
sealed class CategoryState with _$CategoryState {
  const factory CategoryState.initial() = _CategoryInitial;
  const factory CategoryState.loading() = _CategoryLoading;
  const factory CategoryState.refreshing({
    @Default([]) List<Account> categories,
  }) = _CategoryRefreshing;
  const factory CategoryState.loaded({@Default([]) List<Account> categories}) =
      _CategoryLoaded;
  const factory CategoryState.error({required String message}) = _CategoryError;
}

class CategoryCubit extends Cubit<CategoryState> {
  final AccountRepository _repository;
  CategoryCubit(this._repository) : super(const CategoryState.initial());

  TransactionType? _lastType;
  String? _lastKeyword;

  Future<void> fetch({String? keyword, required TransactionType type}) async {
    _lastType = type;
    _lastKeyword = keyword;

    emit(CategoryState.loading());
    await _loadAccounts(keyword: keyword, type: type);
  }

  Future<void> refresh() async {
    final type = _lastType;
    if (type == null) return;

    final currentCategories = state.maybeWhen(
      loaded: (categories) => categories,
      orElse: () => <Account>[],
    );

    emit(CategoryState.refreshing(categories: currentCategories));
    await _loadAccounts(keyword: _lastKeyword, type: type);
  }

  Future<void> _loadAccounts({
    String? keyword,
    required TransactionType type,
  }) async {
    final filter = AccountFilter(
      type: type == TransactionType.expense
          ? AccountType.expense
          : AccountType.income,
      name: keyword,
    );

    try {
      final accounts = await _repository.getAccounts(filter);
      emit(CategoryState.loaded(categories: accounts));
    } catch (e) {
      emit(CategoryState.error(message: e.toString()));
    }
  }
}
