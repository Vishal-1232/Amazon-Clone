import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widgets/account_buttons.dart';
import 'package:amazon_clone/features/wishlist/screens/wishlist_screen.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: 'Your Account',
              onTap: () {
                showSnackBar(context, "Feature will be available in next version");
              },
            ),
            AccountButton(
              text: 'Turn Seller',
              onTap: () {
                showSnackBar(context, "Feature will be available in next version");
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(
              text: 'Log Out',
              onTap: () => showLogoutConfirmationDialog(context),
            ),
            AccountButton(
              text: 'Your Wish List',
              onTap: () {
                Navigator.pushNamed(context, WishlistScreen.routeName);
              },
            ),
          ],
        ),
      ],
    );
  }
}
