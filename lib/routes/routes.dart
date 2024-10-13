import 'package:get/get.dart';

import '../pages/pages.dart';

abstract class AppRoutes {
  static const String home = '/';
  static const String assets = '/assets';

  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: assets,
      page: () => const AssetsPage(),
    ),
  ];
}
