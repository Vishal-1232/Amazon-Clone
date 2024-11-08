import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/admin/models/coupon.dart';
import 'package:amazon_clone/features/admin/screens/category/add_category_screen.dart';
import 'package:amazon_clone/features/admin/screens/coupons/add_coupon_screen.dart';
import 'package:amazon_clone/models/category.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/loader.dart';
import '../../../account/widgets/single_product.dart';
import '../../services/admin_services.dart';

class ManageCouponsScreen extends StatefulWidget {
  static const String routeName = '/manage-coupons';
  const ManageCouponsScreen({super.key});

  @override
  State<ManageCouponsScreen> createState() => _ManageCouponsScreenState();
}

class _ManageCouponsScreenState extends State<ManageCouponsScreen> {
  List<CouponModel>? coupons;
  final AdminServices _adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchAllCoupons();
  }

  fetchAllCoupons() async {
    coupons = await _adminServices.fetchAllCoupons(context: context);
    setState(() {});
  }

  void deleteCoupon(CouponModel coupon, int index) {
    _adminServices.deleteCoupon(
      context: context,
      coupon: coupon,
      onSuccess: () {
        coupons!.removeAt(index);
        setState(() {});
      },
    );
  }

  void navigateToAddCoupon() {
    Navigator.pushNamed(context, AddCouponScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return coupons == null
        ? const Loader()
        : Scaffold(
      body: GridView.builder(
        itemCount: coupons!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemBuilder: (context, index) {
          final couponData = coupons![index];
          return Column(
            children: [
              const SizedBox(
                height: 140,
                child: SingleProduct(
                  image: GlobalVariables.couponImage,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      couponData.couponCode,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  IconButton(
                    onPressed: () => deleteCoupon(couponData, index),
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
        onPressed: navigateToAddCoupon,
        tooltip: 'Add a Coupon',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
    );
  }
}
