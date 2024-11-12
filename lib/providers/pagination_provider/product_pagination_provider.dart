import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/pagination_provider/pagination_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPaginationProvider extends PaginationProvider<Product> {
  ProductPaginationProvider({String categoryId='',String productName='', required BuildContext context})
      : super(
    fetchItems: (page) => HomeServices().fetchCategoryProducts(
      categoryId: categoryId,
      productName: productName,
      page: page,
      context: context,
    ),
  );
}
