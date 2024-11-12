import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amazon_clone/features/home/screens/category_deals_screen.dart';

import '../../../providers/category_provider.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({Key? key}) : super(key: key);

  void navigateToCategoryPage(BuildContext context, String categoryId, String categoryName) {
    Navigator.pushNamed(context, CategoryDealsScreen.routeName,
        arguments: {
          'categoryId': categoryId,
          'categoryName': categoryName,
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const CircularProgressIndicator();
          }

          final categories = provider.categories;
          return ListView.builder(
            itemCount: categories?.length ?? 0,
            scrollDirection: Axis.horizontal,
            itemExtent: 75,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => navigateToCategoryPage(
                  context,
                  categories[index].id!,
                  categories[index].name,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          categories![index].image,
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                    Text(
                      categories[index].name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
