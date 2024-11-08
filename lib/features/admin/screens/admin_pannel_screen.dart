import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/admin/screens/category/manage_category_screen.dart';
import 'package:amazon_clone/features/admin/screens/coupons/manage_coupons_screen.dart';
import 'package:amazon_clone/features/admin/screens/products/posts_screen.dart';
import 'package:flutter/material.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.notifications_active_outlined),
              title: const Text("Manage Products"),
              tileColor: Colors.orange.shade100,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PostsScreen(),));
              },
            ),
            const SizedBox(height: 20,),
            ListTile(
              leading: const Icon(Icons.notifications_active_outlined),
              title: const Text("Manage Categories"),
              tileColor: Colors.orange.shade100,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageCategoryScreen(),));
              },
            ),
            const SizedBox(height: 20,),
            ListTile(
              leading: const Icon(Icons.notifications_active_outlined),
              title: const Text("Manage Coupons"),
              tileColor: Colors.orange.shade100,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageCouponsScreen(),));
              },
            ),
            const SizedBox(height: 20,),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log out"),
              tileColor: Colors.orange.shade100,
              onTap: () => AccountServices().logOut(context),
            ),
          ],
        ),
      ),
    );
  }
}
