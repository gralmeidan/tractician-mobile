import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/bindings.dart';

import 'routes/routes.dart';

void main() {
  runApp(const TracticianApp());
}

class TracticianApp extends StatelessWidget {
  const TracticianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tractician',
      initialBinding: AppBindings(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      getPages: AppRoutes.routes,
      initialRoute: AppRoutes.home,
    );
  }
}
