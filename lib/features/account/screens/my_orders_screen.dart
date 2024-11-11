import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widgets/ordered_product.dart';
import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';
import '../../../models/order.dart';

class MyOrdersScreen extends StatefulWidget {
  static const String routeName = '/my-orders';
  List<Order> myOrders;

  MyOrdersScreen({super.key, required this.myOrders});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final _accountServices = AccountServices();
  final searchController = TextEditingController();
  String searchOrderProductQuery = "";

  navigateToSearchScreen(String searchQuery) {}

  void displaySearchResults(String searchQuery) async {
    widget.myOrders = await _accountServices.fetchMyOrders(
        context: context, productName: searchQuery);
    setState(() {
    searchOrderProductQuery = searchQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search Amazon.in',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: Colors.black, size: 25),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Orders",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              onFieldSubmitted: displaySearchResults,
              onChanged: (value) {
                if(value.isEmpty){
                  displaySearchResults(value);
                }
              },
              decoration: InputDecoration(
                prefixIcon: InkWell(
                  onTap: () => displaySearchResults,
                  child: const Padding(
                    padding: EdgeInsets.only(
                      left: 6,
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 23,
                    ),
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.only(top: 10),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38)),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38)),
                hintText: 'Search all orders',
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.myOrders.length,
              itemBuilder: (context, index) {
                return OrderedProduct(
                  order: widget.myOrders[index],
                  searchQuery: searchOrderProductQuery,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }
}
