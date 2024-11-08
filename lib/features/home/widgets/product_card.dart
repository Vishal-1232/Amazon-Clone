import 'package:amazon_clone/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(
        context); // Make sure to call super.build for AutomaticKeepAliveClientMixin

    return Column(
      children: [
        SizedBox(
          height: 130,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black12,
                width: 0.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: CachedNetworkImage(
                key: UniqueKey(),
                imageUrl: widget.product.images[0],
                fit: BoxFit.cover,
                //placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(left: 5, top: 5, right: 5),
          child: Text(
            widget.product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
