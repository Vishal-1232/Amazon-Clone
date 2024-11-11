import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';

class OrderedProduct extends StatelessWidget {
  final Order order;
  final String searchQuery;
  const OrderedProduct({super.key, required this.order, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: order.products.length,
      itemBuilder: (context, index) {
        final product = order.products[index];
        if(searchQuery.isNotEmpty && !product.name.toLowerCase().contains(searchQuery.trim().toLowerCase())) return const SizedBox(height: 0,);
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
              width: 0.5,
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Row(
            children: [
              Image.network(
                product.images.first,
                fit: BoxFit.cover,
                height: 120,
                width: 120,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 235,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      product.name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Ordered on ${formatDateTime(order.orderedAt)}",
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
