import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel>? _categories;
  bool _isLoading = false;

  CategoryProvider(BuildContext context) {
    // Fetch categories when the provider is first created
    fetchCategories(context);
    // fetch deal of day
    fetchDealOfTheDay(context);
  }

  List<CategoryModel>? get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories(BuildContext context) async {
    if (_categories == null) {
      _isLoading = true;
      notifyListeners();

      _categories = await HomeServices().fetchCategories(context: context);

      _isLoading = false;
      notifyListeners(); // Notify consumers that data is available
    }
  }


  // for deal of day
  Product? _product;
  Product? get product => _product;
  bool _isDealLoading = false;
  bool get isDealLoading => _isDealLoading;
  Future<void>fetchDealOfTheDay(BuildContext context)async{
    if(_product==null){
      _isDealLoading = true;
      notifyListeners();

      _product = await HomeServices().fetchDealOfDay(context: context);

      _isDealLoading = false;
      notifyListeners(); // Notify consumers that data is available
    }
  }
}
