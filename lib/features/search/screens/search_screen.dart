import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_pagination_provider.dart';
import '../widget/searched_product.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';
  final String searchQuery;
  const SearchScreen({
    Key? key,
    required this.searchQuery,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late ProductPaginationProvider _paginationProvider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _paginationProvider = ProductPaginationProvider(productName: widget.searchQuery, context: context);
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

  void navigateToSearchScreen(String query) {
    Navigator.pushReplacementNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductPaginationProvider>.value(
      value: _paginationProvider,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    margin: const EdgeInsets.only(left: 15),
                    child: Material(
                      borderRadius: BorderRadius.circular(7),
                      elevation: 1,
                      child: TextFormField(
                        onFieldSubmitted: navigateToSearchScreen,
                        decoration: InputDecoration(
                          prefixIcon: InkWell(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.only(
                                left: 6,
                              ),
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 23,
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(top: 10),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black38,
                              width: 1,
                            ),
                          ),
                          hintText: 'Search Amazon.in',
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: 42,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Icon(Icons.mic, color: Colors.black, size: 25),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const AddressBox(),
              const SizedBox(height: 10),
              Consumer<ProductPaginationProvider>(
                builder: (context, provider, _) {
                  return Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemCount: provider.items.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ProductDetailScreen.routeName,
                                arguments: provider.items[index],
                              );
                            },
                            child: SearchedProduct(
                              product: provider.items[index],
                            ),
                          );
                        },
                      ),
                      if (provider.isLoading) const Loader(),
                    ],
                  );
                },
              )
            ],
          ),
        )
      ),
    );
  }
}
