import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_pagination_provider.dart';
import '../widgets/product_card.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String categoryId;
  final String categoryName;
  const CategoryDealsScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName
  }) : super(key: key);

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  late ProductPaginationProvider _paginationProvider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _paginationProvider = ProductPaginationProvider(categoryId: widget.categoryId, context: context);
    // Load initial items
    _paginationProvider.loadMore().then((value) {
      checkAndLoadMoreIfNeeded(context);
    },);

    // Add scroll listener
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double threshold = maxScroll * 0.8; // 80% of the scroll extent

      if (currentScroll >= threshold) {
        _paginationProvider.loadMore();
      }
    });

  }
  Future<void> checkAndLoadMoreIfNeeded(BuildContext context) async {
    // Wait for the next frame to ensure layout is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.position.maxScrollExtent <= _scrollController.position.viewportDimension) {
        // If content doesn't require scrolling, load more items
        _paginationProvider.loadMore().then((_) {
          // Recursively check again in case more items are still needed
          if (_scrollController.position.maxScrollExtent <= _scrollController.position.viewportDimension &&
              _paginationProvider.hasMore) {
            checkAndLoadMoreIfNeeded(context);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductPaginationProvider>.value(
      value: _paginationProvider,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryName),
        ),
        body: Consumer<ProductPaginationProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.items.isEmpty) {
              return const Loader();
            }

            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    itemCount: provider.items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final product = provider.items[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ProductDetailScreen.routeName,
                            arguments: product,
                          );
                        },
                        child: ProductCard(key: ValueKey(product.id),product: product),
                      );
                    },
                  ),
                ),
                if (provider.isLoading) const Loader(),
              ],
            );
          },
        ),
      ),
    );
    // return Scaffold(
    //   appBar: PreferredSize(
    //     preferredSize: const Size.fromHeight(50),
    //     child: AppBar(
    //       flexibleSpace: Container(
    //         decoration: const BoxDecoration(
    //           gradient: GlobalVariables.appBarGradient,
    //         ),
    //       ),
    //       title: Text(
    //         widget.categoryName,
    //         style: const TextStyle(
    //           color: Colors.black,
    //         ),
    //       ),
    //     ),
    //   ),
    //   body: productList == null
    //       ? const Loader()
    //       : GridView.builder(
    //     scrollDirection: Axis.vertical,
    //     padding: const EdgeInsets.only(left: 15),
    //     itemCount: productList!.length,
    //     gridDelegate:
    //     const SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 2,
    //       childAspectRatio: 1.0,
    //       mainAxisSpacing: 10,
    //     ),
    //     itemBuilder: (context, index) {
    //       final product = productList![index];
    //       return GestureDetector(
    //         onTap: () {
    //           Navigator.pushNamed(
    //             context,
    //             ProductDetailScreen.routeName,
    //             arguments: product,
    //           );
    //         },
    //         child: Column(
    //           children: [
    //             SizedBox(
    //               height: 130,
    //               child: DecoratedBox(
    //                 decoration: BoxDecoration(
    //                   border: Border.all(
    //                     color: Colors.black12,
    //                     width: 0.5,
    //                   ),
    //                 ),
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(10),
    //                   child: Image.network(
    //                     product.images[0],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Container(
    //               alignment: Alignment.bottomCenter,
    //               padding: const EdgeInsets.only(
    //                 left: 5,
    //                 top: 5,
    //                 right: 5,
    //               ),
    //               child: Text(
    //                 product.name,
    //                 maxLines: 1,
    //                 overflow: TextOverflow.ellipsis,
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
