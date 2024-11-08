import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../../constants/global_variables.dart';
import '../../../../constants/utils.dart';
import '../../services/admin_services.dart';

class AddCategoryScreen extends StatefulWidget {
  static const String routeName = '/add-category';
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController categoryNameController = TextEditingController();
  final AdminServices _adminServices = AdminServices();

  String? category;
  File? image;
  final _addCategoryFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    categoryNameController.dispose();
  }

  void save() {
    if (_addCategoryFormKey.currentState!.validate() && image!=null) {
      _adminServices.addCategory(context: context, name: categoryNameController.text, image: image!);
    }
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      image = res.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'Add Category',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addCategoryFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                image!=null
                    ? Image.file(
                  image!,
                  fit: BoxFit.cover,
                  height: 200,
                )
                    : GestureDetector(
                  onTap: selectImages,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    dashPattern: const [10, 4],
                    strokeCap: StrokeCap.round,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.folder_open,
                            size: 40,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Select Category Image',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: categoryNameController,
                  hintText: 'Category Name',
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Add',
                  color: GlobalVariables.secondaryColor,
                  onTap: save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
