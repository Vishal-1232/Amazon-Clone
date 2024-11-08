import 'package:amazon_clone/features/admin/screens/category/add_category_screen.dart';
import 'package:amazon_clone/models/category.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/loader.dart';
import '../../../account/widgets/single_product.dart';
import '../../services/admin_services.dart';

class ManageCategoryScreen extends StatefulWidget {
  static const String routeName = '/manage-category';
  const ManageCategoryScreen({super.key});

  @override
  State<ManageCategoryScreen> createState() => _ManageCategoryScreenState();
}

class _ManageCategoryScreenState extends State<ManageCategoryScreen> {
  List<CategoryModel>? categories;
  final AdminServices _adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchAllCategories();
  }

  fetchAllCategories() async {
    categories = await _adminServices.fetchAllCategories(context: context);
    setState(() {});
  }

  void deleteCategory(CategoryModel category, int index) {
    _adminServices.deleteCategory(
      context: context,
      category: category,
      onSuccess: () {
        categories!.removeAt(index);
        setState(() {});
      },
    );
  }

  void navigateToAddCategory() {
    Navigator.pushNamed(context, AddCategoryScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return categories == null
        ? const Loader()
        : Scaffold(
      body: GridView.builder(
        itemCount: categories!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemBuilder: (context, index) {
          final categoryData = categories![index];
          return Column(
            children: [
              SizedBox(
                height: 140,
                child: SingleProduct(
                  image: categoryData.image,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      categoryData.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  IconButton(
                    onPressed: () => deleteCategory(categoryData, index),
                    icon: const Icon(
                      Icons.delete_outline,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddCategory,
        tooltip: 'Add a Category',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
    );
  }
}
