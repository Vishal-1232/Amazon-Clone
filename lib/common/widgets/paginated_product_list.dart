import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_pagination_provider.dart';

class PaginatedProductList extends StatefulWidget {
  final ProductPaginationProvider paginationProvider;
  final Widget Function(BuildContext, int) itemBuilder;
  final ScrollController scrollController;

  const PaginatedProductList({
    Key? key,
    required this.paginationProvider,
    required this.itemBuilder,
    required this.scrollController,
  }) : super(key: key);

  @override
  _PaginatedProductListState createState() => _PaginatedProductListState();
}

class _PaginatedProductListState extends State<PaginatedProductList> {

  @override
  void initState() {
    super.initState();
    // Load initial items
    widget.paginationProvider.loadMore().then((_) {
      _checkAndLoadMoreIfNeeded();
    });

    widget.scrollController.addListener(() {
      double maxScroll = widget.scrollController.position.maxScrollExtent;
      double currentScroll = widget.scrollController.position.pixels;
      double threshold = maxScroll * 0.8;

      if (currentScroll >= threshold) {
        widget.paginationProvider.loadMore();
      }
    });
  }

  Future<void> _checkAndLoadMoreIfNeeded() async {
    // Wait for the next frame to ensure layout is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController.position.maxScrollExtent <= widget.scrollController.position.viewportDimension) {
        // If content doesn't require scrolling, load more items
        widget.paginationProvider.loadMore().then((_) {
          // Recursively check again in case more items are still needed
          if (widget.scrollController.position.maxScrollExtent <= widget.scrollController.position.viewportDimension &&
              widget.paginationProvider.hasMore) {
            _checkAndLoadMoreIfNeeded();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductPaginationProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: widget.scrollController,
                itemCount: provider.items.length,
                itemBuilder: widget.itemBuilder,
              ),
            ),
            if (provider.isLoading) const CircularProgressIndicator(), // You can replace this with your own loader widget
          ],
        );
      },
    );
  }
}
