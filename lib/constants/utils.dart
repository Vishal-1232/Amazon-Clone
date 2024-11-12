import 'dart:io';

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../features/account/services/account_services.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

void showToast(BuildContext context, String title){
  DelightToastBar(
    autoDismiss: true,
    position: DelightSnackbarPosition.top,
    builder: (context) => ToastCard(
      leading: const Icon(
        Icons.flutter_dash,
        size: 28,
      ),
      color: Colors.green.shade100,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    ),
  ).show(context);
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (files != null && files.files.isNotEmpty) {
      for (int i = 0; i < files.files.length; i++) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}

String formatNumber(double number){
  // Create a NumberFormat instance with 2 decimal places
  final formatter = NumberFormat('#,##0.00');

  // Format the number
  String formattedNumber = formatter.format(number);

  return formattedNumber;
}

String formatDateTime(int dateTime){
  return DateFormat("dd MMM, yyyy").format(
    DateTime.fromMillisecondsSinceEpoch(dateTime),
  );
}

selectDate(BuildContext context) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1600),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );
  // if(picked != null){
  //   setState(() {
  //     //dateController.text = picked.toString().split(" ")[0];
  //     dateController.text=DateFormat('yMMMMd').format(picked);
  //   });
  // }
}

void showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              // Add your logout logic here, e.g., clearing user data or navigating to login screen
              AccountServices().logOut(context);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red), // Optional: make the logout text red
            ),
          ),
        ],
      );
    },
  );
}


