import 'package:get/get.dart';

import '../controllers/controllers.dart';
import '../services/services.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TracticianService(), fenix: true);
    Get.lazyPut(() => AssetTreeController(), fenix: true);
  }
}
