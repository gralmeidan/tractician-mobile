import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/company.model.dart';

class TracticianService extends GetxService {
  static TracticianService get to => Get.find<TracticianService>();

  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://fake-api.tractian.com',
    ),
  );

  Future<List<Company>> getCompanies() async {
    final response = await _dio.get('/companies');

    return (response.data as List)
        .map(
          (e) => Company.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
