import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/core/models/pagination_meta.dart';
import 'package:dompet_app/core/models/pagination_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_cubit.freezed.dart';

typedef PageFetcher<T, P> =
    Future<PaginationResult<T>> Function({
      required Pagination pagination,
      P? filter,
    });

@freezed
sealed class PaginationState<T> with _$PaginationState<T> {
  const factory PaginationState.initial() = PaginationInitial;

  const factory PaginationState.loading() = PaginationLoading;

  const factory PaginationState.success({
    required List<T> items,
    required PaginationMeta meta,
  }) = PaginationSuccess;

  const factory PaginationState.loadingMore({
    required List<T> items,
    required PaginationMeta meta,
  }) = PaginationLoadingMore;

  const factory PaginationState.failure({required String message}) =
      PaginationFailure;

  const factory PaginationState.loadingMoreFailure({
    required List<T> items,
    required PaginationMeta meta,
    required String message,
  }) = PaginationLoadingMoreFailure;
}

class PaginationCubit<T, P> extends Cubit<PaginationState<T>> {
  final PageFetcher<T, P> _fetcher;
  P? _filter;

  PaginationCubit({required PageFetcher<T, P> fetcher, P? filter})
    : _fetcher = fetcher,
      _filter = filter,
      super(const PaginationState.initial());

  Future<void> fetchInitial({P? filter}) async {
    if (state is PaginationLoading) return;
    if (filter != null) _filter = filter;

    emit(const PaginationState.loading());
    await _fetch(page: 1, existingItems: []);
  }

  Future<void> fetchMore() async {
    final current = switch (state) {
      PaginationSuccess<T> s => s,
      _ => null,
    };

    if (current == null || !current.meta.hasMore) return;

    emit(PaginationState.loadingMore(items: current.items, meta: current.meta));

    await _fetch(page: current.meta.page + 1, existingItems: current.items);
  }

  Future<void> _fetch({
    required int page,
    required List<T> existingItems,
  }) async {
    try {
      final paginatedResult = await _fetcher(
        pagination: Pagination(page: page),
        filter: _filter,
      );

      emit(
        PaginationState.success(
          items: [...existingItems, ...paginatedResult.items],
          meta: paginatedResult.meta,
        ),
      );
    } catch (e) {
      if (existingItems.isEmpty) {
        emit(PaginationState.failure(message: e.toString()));
      } else {
        final current = state as PaginationLoadingMore<T>;
        emit(
          PaginationState.loadingMoreFailure(
            items: current.items,
            meta: current.meta,
            message: e.toString(),
          ),
        );
      }
    }
  }
}
