import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/pagination_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPaginationProvider extends PaginationProvider<Product> {
  ProductPaginationProvider({required String categoryId, required BuildContext context})
      : super(
    fetchItems: (page) => HomeServices().fetchCategoryProducts(
      categoryId: categoryId,
      page: page,
      context: context,
    ),
  );
}
