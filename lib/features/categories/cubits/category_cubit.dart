import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/enums/enum.dart';
import 'package:dompet_app/features/accounts/models/account.dart';
import 'package:dompet_app/features/accounts/models/account_filter.dart';
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
  bool _lastWithBudget = false;

  Future<void> fetch({
    String? keyword,
    required TransactionType type,
    bool withBudget = false,
  }) async {
    _lastType = type;
    _lastKeyword = keyword;
    _lastWithBudget = withBudget;

    emit(CategoryState.loading());
    await _loadAccounts(keyword: keyword, type: type, withBudget: withBudget);
  }

  /// FIX-14 (IMP-3): list arsip mirror list aktif, per tipe.
  Future<void> fetchArchived({
    String? keyword,
    required TransactionType type,
  }) async {
    emit(CategoryState.loading());
    try {
      final filter = AccountFilter(
        type: type == TransactionType.expense
            ? AccountType.expense
            : AccountType.income,
        name: keyword,
      );
      final accounts = await _repository.getArchivedAccounts(filter: filter);
      // Sistem tak bisa diarsipkan user; tampilkan hanya buatan user
      // agar konsisten dengan section "Kategori Saya" di list aktif.
      final userOnly = accounts.where((a) => !a.isSystem).toList();
      emit(CategoryState.loaded(categories: userOnly));
    } catch (e) {
      emit(CategoryState.error(message: e.toString()));
    }
  }

  Future<Account?> getCategoryById(int id) async {
    final account = await _repository.getAccount(id);
    return account;
  }

  Future<void> refresh() async {
    final type = _lastType;
    if (type == null) return;

    final currentCategories = state.maybeWhen(
      loaded: (categories) => categories,
      orElse: () => <Account>[],
    );

    emit(CategoryState.refreshing(categories: currentCategories));
    await _loadAccounts(
      keyword: _lastKeyword,
      type: type,
      withBudget: _lastWithBudget,
    );
  }

  Future<void> _loadAccounts({
    String? keyword,
    required TransactionType type,
    bool withBudget = false,
  }) async {
    final filter = AccountFilter(
      type: type == TransactionType.expense
          ? AccountType.expense
          : AccountType.income,
      name: keyword,
    );

    try {
      final accounts = await _repository.getAccounts(
        filter: filter,
        withBudget: withBudget,
      );
      emit(CategoryState.loaded(categories: accounts));
    } catch (e) {
      emit(CategoryState.error(message: e.toString()));
    }
  }
}
