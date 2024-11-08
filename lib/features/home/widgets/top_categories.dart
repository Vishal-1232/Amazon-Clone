import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/home/screens/category_deals_screen.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:flutter/material.dart';

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
      child: FutureBuilder(future: HomeServices().fetchCategories(context: context), builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return const CircularProgressIndicator();
        }
        return ListView.builder(
          itemCount: snapshot.data?.length,
          scrollDirection: Axis.horizontal,
          itemExtent: 75,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => navigateToCategoryPage(
                context,
                snapshot.data![index].id!,
                snapshot.data![index].name,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        snapshot.data![index].image,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                  Text(
                    snapshot.data![index].name,
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
      },),
    );
  }
}
