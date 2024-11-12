import 'package:amazon_clone/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';

import '../../../constants/utils.dart';
import '../../../models/product.dart';

class DealOfDay extends StatelessWidget {
  const DealOfDay({Key? key}) : super(key: key);

  void navigateToDetailScreen(BuildContext context, Product product) {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isDealLoading) {
          return const Loader();
        }

        final product = provider.product;
        if (product == null || product.name.isEmpty) {
          return const SizedBox();
        }

        return GestureDetector(
          onTap: () => navigateToDetailScreen(context, product),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 10, top: 15),
                child: const Text(
                  'Deal of the day',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Image.network(
                product.images[0],
                height: 235,
                fit: BoxFit.fitHeight,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.topLeft,
                child: Text(
                  '₹${formatNumber(product.price)}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 15, top: 5, right: 40),
                child: Text(
                  product.description.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: product.images
                      .map(
                        (e) => Image.network(
                      e,
                      fit: BoxFit.fitWidth,
                      width: 100,
                      height: 100,
                    ),
                  )
                      .toList(),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ).copyWith(left: 15),
                alignment: Alignment.topLeft,
                child: Text(
                  'See all deals',
                  style: TextStyle(
                    color: Colors.cyan[800],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
