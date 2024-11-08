import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/models/coupon.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_button.dart';
import '../services/cart_services.dart';

class CartSubtotal extends StatefulWidget {
  const CartSubtotal({Key? key}) : super(key: key);

  @override
  State<CartSubtotal> createState() => _CartSubtotalState();
}

class _CartSubtotalState extends State<CartSubtotal> {
  final couponCodeController = TextEditingController();
  CouponModel? couponModel;

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Subtotal ',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              couponModel!=null?Text("₹${formatNumber(userProvider.cartTotalAmount)}",style: const TextStyle(fontSize: 20,color: Colors.green,fontWeight: FontWeight.bold),):Text(
                '₹${formatNumber(userProvider.cartTotalAmount)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              Flexible(
                flex: 2,
                  child: TextField(
                    controller: couponCodeController,
                    decoration: InputDecoration(
                        border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Enter Coupon"),
                  )),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                  child: CustomButton(
                    text: "Apply",
                    onTap: applyCoupon,
                    color: Colors.greenAccent,
                  )),
            ],
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
  void applyCoupon()async{
    couponModel = await CartServices().applyCoupon(context: context, couponCode: couponCodeController.text,onlyCouponCheck: true);
    print(couponModel);
// Update the discount in the provider
    context.read<UserProvider>().applyCoupon(couponModel?.discountValue??0.0,couponModel);
  }
}
