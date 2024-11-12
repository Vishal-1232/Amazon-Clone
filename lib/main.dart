import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/splash_screen/screens/splash_screen.dart';
import 'package:amazon_clone/providers/category_provider.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/router.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => CategoryProvider(context),
    )
  ], child: DevicePreview(enabled: !kReleaseMode,builder:(context)=> const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazon',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme:
              const ColorScheme.light(primary: GlobalVariables.secondaryColor),
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black), elevation: 0)),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const SplashScreen(),
    );
  }
}
