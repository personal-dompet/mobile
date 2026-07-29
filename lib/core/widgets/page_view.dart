import 'package:dompet_app/core/cubits/pagination_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaginationListView<T, P> extends StatefulWidget {
  final PaginationCubit<T, P> cubit;
  final SliverMultiBoxAdaptorWidget Function(
    BuildContext context,
    List<T> items,
  )
  listBuilder;
  final String emptyMessage;
  final String loadMoreErrorMessage;
  final Widget? header;
  final Widget? empty;
  final Widget? initialLoader;
  final Widget? errorWidget;

  const PaginationListView({
    super.key,
    required this.cubit,
    required this.listBuilder,
    this.emptyMessage = 'Belum ada data',
    this.loadMoreErrorMessage = 'Gagal memuat lebih banyak data',
    this.header,
    this.empty,
    this.initialLoader,
    this.errorWidget,
  });

  @override
  State<PaginationListView<T, P>> createState() =>
      _PaginationListViewState<T, P>();
}

class _PaginationListViewState<T, P> extends State<PaginationListView<T, P>> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollController.position;
    final nearBottom = pos.pixels >= pos.maxScrollExtent - 300;
    if (nearBottom) widget.cubit.fetchMore();
  }

  Widget _buildBottomWidget(PaginationState<T> state) {
    return switch (state) {
      PaginationLoadingMore() => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      PaginationLoadingMoreFailure() => Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.loadMoreErrorMessage),
            TextButton(
              onPressed: widget.cubit.fetchMore,
              child: const Text('Ulangi'),
            ),
          ],
        ),
      ),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaginationCubit<T, P>, PaginationState<T>>(
      bloc: widget.cubit,
      builder: (context, state) {
        return CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (widget.header != null)
              PinnedHeaderSliver(
                child: ColoredBox(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: widget.header!,
                ),
              ),

            switch (state) {
              PaginationInitial() || PaginationLoading() => SliverFillRemaining(
                child:
                    widget.initialLoader ??
                    const Center(child: CircularProgressIndicator()),
              ),

              PaginationFailure(:final message) => SliverFillRemaining(
                child:
                    widget.errorWidget ??
                    Center(
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
              ),

              PaginationSuccess(:final items) when items.isEmpty =>
                SliverFillRemaining(
                  hasScrollBody: false,
                  child:
                      widget.empty ?? Center(child: Text(widget.emptyMessage)),
                ),

              PaginationLoadingMore(:final items) ||
              PaginationLoadingMoreFailure(:final items) ||
              PaginationSuccess(:final items) => SliverMainAxisGroup(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: widget.listBuilder(context, items),
                  ),
                  SliverToBoxAdapter(child: _buildBottomWidget(state)),
                ],
              ),
            },
            SliverToBoxAdapter(child: SizedBox(height: 28)),
          ],
        );
      },
    );
  }
}
