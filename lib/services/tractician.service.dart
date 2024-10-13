import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/models.dart';

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

  Future<List<dynamic>> getAssets(String companyId) async {
    final response = await _dio.get('/companies/$companyId/assets');

    return response.data as List<dynamic>;
  }

  Future<List<dynamic>> getLocations(String companyId) async {
    final response = await _dio.get('/companies/$companyId/locations');

    return response.data as List<dynamic>;
  }
}
