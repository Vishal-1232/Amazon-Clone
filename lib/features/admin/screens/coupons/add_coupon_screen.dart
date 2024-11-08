import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/features/admin/models/coupon.dart';
import 'package:amazon_clone/models/category.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../constants/global_variables.dart';
import '../../services/admin_services.dart';

class AddCouponScreen extends StatefulWidget {
  static const String routeName = '/add-coupon';

  const AddCouponScreen({super.key});

  @override
  State<AddCouponScreen> createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  final _addCouponFormKey = GlobalKey<FormState>();

  // Form fields
  String couponCode = '';
  String description = '';
  String discountType = 'percentage';
  double discountValue = 0.0;
  double minimumPurchaseRequirement = 0.0;
  double? maximumDiscountLimit;
  DateTime? startDate;
  DateTime? endDate;
  int perUserLimit = 1;
  int? totalUsageLimit;
  List<String> eligibleProducts = [];
  List<String> excludedProducts = [];
  List<String> eligibleCategories = [];
  List<String> excludedCategories = [];
  String userRestrictions = 'all';
  bool usageStatus = true; // Active by default
  bool autoApply = false;

  // Date pickers
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  final _adminServices = AdminServices();

  void save() {
    if (_addCouponFormKey.currentState!.validate()) {
      _addCouponFormKey.currentState!.save();
      _adminServices.addCoupon(
          context: context,
          coupon: CouponModel(
              couponCode: couponCode,
              description: description,
              discountType: discountType,
              discountValue: discountValue,
              startDate: startDate!,
              endDate: endDate!));
    }
  }

  // Mock Data for Products and Categories (In a real app, this would come from the server)
  List<String> allProducts = [];
  List<String> allCategories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    List<Product> products = await _adminServices.fetchAllProducts(context);
    List<CategoryModel> categories = await _adminServices.fetchAllCategories(context: context);

    for (var category in categories) {
      allCategories.add(category.name);
    }
    for (var product in products) {
      allProducts.add(product.name);
    }
  }

  // Helper function to show the multi-select dialog
  Future<void> _showMultiSelectDialog({
    required List<String> items,
    required List<String> selectedItems,
    required String title,
    required Function(List<String>) onSelectionChanged,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          selectedItems: selectedItems,
          title: title,
          onSelectionChanged: onSelectionChanged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Coupon"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _addCouponFormKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Coupon Code"),
                onSaved: (value) {
                  couponCode = value!.toUpperCase().trim();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a coupon code';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                onSaved: (value) {
                  description = value!.trim();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: discountType,
                items: ['percentage', 'fixed']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    discountType = value!;
                  });
                },
                decoration: const InputDecoration(labelText: "Discount Type"),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Discount Value"),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  discountValue = double.parse(value!);
                },
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Please enter a valid discount value';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Minimum Purchase Requirement"),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  //  minimumPurchaseRequirement = double.parse(value!);
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Maximum Discount Limit"),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  maximumDiscountLimit =
                      value!.isNotEmpty ? double.parse(value) : null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Start Date"),
                      readOnly: true,
                      controller: TextEditingController(
                        text: startDate == null
                            ? ''
                            : DateFormat.yMd().format(startDate!),
                      ),
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: "End Date"),
                      readOnly: true,
                      controller: TextEditingController(
                        text: endDate == null
                            ? ''
                            : DateFormat.yMd().format(endDate!),
                      ),
                      onTap: () => _selectDate(context, false),
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Per User Limit"),
                keyboardType: TextInputType.number,
                initialValue: '1',
                onSaved: (value) {
                  perUserLimit = int.parse(value!);
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Total Usage Limit"),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  totalUsageLimit = value!.isNotEmpty ? int.parse(value) : null;
                },
              ),
              // Add eligible and excluded product/category selection widgets here.
              DropdownButtonFormField<String>(
                value: userRestrictions,
                items: ['new', 'existing', 'all']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    userRestrictions = value!;
                  });
                },
                decoration:
                    const InputDecoration(labelText: "User Restrictions"),
              ),
              SwitchListTile(
                title: const Text("Usage Status"),
                value: usageStatus,
                onChanged: (bool value) {
                  setState(() {
                    usageStatus = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text("Auto Apply"),
                value: autoApply,
                onChanged: (bool value) {
                  setState(() {
                    autoApply = value;
                  });
                },
              ),
              // Eligible Products Multi-Select
              ListTile(
                title: Text('Eligible Products'),
                subtitle: Text(eligibleProducts.isEmpty
                    ? 'No products selected'
                    : eligibleProducts.join(', ')),
                trailing: Icon(Icons.arrow_drop_down),
                onTap: () => _showMultiSelectDialog(
                  items: allProducts,
                  selectedItems: eligibleProducts,
                  title: 'Select Eligible Products',
                  onSelectionChanged: (selected) {
                    setState(() {
                      eligibleProducts = selected;
                    });
                  },
                ),
              ),
              // Excluded Products Multi-Select
              ListTile(
                title: Text('Excluded Products'),
                subtitle: Text(excludedProducts.isEmpty
                    ? 'No products selected'
                    : excludedProducts.join(', ')),
                trailing: Icon(Icons.arrow_drop_down),
                onTap: () => _showMultiSelectDialog(
                  items: allProducts,
                  selectedItems: excludedProducts,
                  title: 'Select Excluded Products',
                  onSelectionChanged: (selected) {
                    setState(() {
                      excludedProducts = selected;
                    });
                  },
                ),
              ),
              // Eligible Categories Multi-Select
              ListTile(
                title: Text('Eligible Categories'),
                subtitle: Text(eligibleCategories.isEmpty
                    ? 'No categories selected'
                    : eligibleCategories.join(', ')),
                trailing: Icon(Icons.arrow_drop_down),
                onTap: () => _showMultiSelectDialog(
                  items: allCategories,
                  selectedItems: eligibleCategories,
                  title: 'Select Eligible Categories',
                  onSelectionChanged: (selected) {
                    setState(() {
                      eligibleCategories = selected;
                    });
                  },
                ),
              ),
              // Excluded Categories Multi-Select
              ListTile(
                title: const Text('Excluded Categories'),
                subtitle: Text(excludedCategories.isEmpty
                    ? 'No categories selected'
                    : excludedCategories.join(', ')),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () => _showMultiSelectDialog(
                  items: allCategories,
                  selectedItems: excludedCategories,
                  title: 'Select Excluded Categories',
                  onSelectionChanged: (selected) {
                    setState(() {
                      excludedCategories = selected;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Add Coupon',
                color: GlobalVariables.secondaryColor,
                onTap: save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Multi-select dialog widget
class MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final String title;
  final Function(List<String>) onSelectionChanged;

  MultiSelectDialog({
    required this.items,
    required this.selectedItems,
    required this.title,
    required this.onSelectionChanged,
  });

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  List<String> _tempSelectedItems = [];

  @override
  void initState() {
    _tempSelectedItems = List.from(widget.selectedItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items.map((item) {
            return CheckboxListTile(
              title: Text(item),
              value: _tempSelectedItems.contains(item),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _tempSelectedItems.add(item);
                  } else {
                    _tempSelectedItems.remove(item);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            widget.onSelectionChanged(_tempSelectedItems);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
