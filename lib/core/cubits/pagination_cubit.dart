import 'package:bloc/bloc.dart';
import 'package:dompet_app/core/models/pagination.dart';
import 'package:dompet_app/core/models/pagination_meta.dart';
import 'package:dompet_app/core/models/pagination_result.dart';

typedef PageFetcher<T, P> =
    Future<PaginationResult<T>> Function({
      required Pagination pagination,
      P? filter,
    });

sealed class PaginationState<T> {
  const PaginationState();

  const factory PaginationState.initial() = PaginationInitial<T>;
  const factory PaginationState.loading() = PaginationLoading<T>;
  const factory PaginationState.success({
    required List<T> items,
    required PaginationMeta meta,
  }) = PaginationSuccess<T>;
  const factory PaginationState.loadingMore({
    required List<T> items,
    required PaginationMeta meta,
  }) = PaginationLoadingMore<T>;
  const factory PaginationState.failure({required String message}) =
      PaginationFailure<T>;
  const factory PaginationState.loadingMoreFailure({
    required List<T> items,
    required PaginationMeta meta,
    required String message,
  }) = PaginationLoadingMoreFailure<T>;
}

final class PaginationInitial<T> extends PaginationState<T> {
  const PaginationInitial();
}

final class PaginationLoading<T> extends PaginationState<T> {
  const PaginationLoading();
}

final class PaginationSuccess<T> extends PaginationState<T> {
  final List<T> items;
  final PaginationMeta meta;

  const PaginationSuccess({required this.items, required this.meta});
}

final class PaginationLoadingMore<T> extends PaginationState<T> {
  final List<T> items;
  final PaginationMeta meta;

  const PaginationLoadingMore({required this.items, required this.meta});
}

final class PaginationFailure<T> extends PaginationState<T> {
  final String message;

  const PaginationFailure({required this.message});
}

final class PaginationLoadingMoreFailure<T> extends PaginationState<T> {
  final List<T> items;
  final PaginationMeta meta;
  final String message;

  const PaginationLoadingMoreFailure({
    required this.items,
    required this.meta,
    required this.message,
  });
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
