import 'package:get/get.dart';

import '../services/tractician.service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TracticianService());
  }
}
