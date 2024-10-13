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

  Future<List<dynamic>> _getAssets(String companyId) async {
    final response = await _dio.get('/companies/$companyId/assets');

    return response.data as List<dynamic>;
  }

  Future<List<dynamic>> _getLocations(String companyId) async {
    final response = await _dio.get('/companies/$companyId/locations');

    return response.data as List<dynamic>;
  }

  void _processItem(
    TreeItem item,
    Map<String, TreeItem> items,
    Map<String, Set<TreeItem>> orphans,
    Set<TreeItem> root,
  ) {
    items[item.id] = item;

    if (orphans.containsKey(item.id)) {
      item.children.addAll(orphans[item.id]!);
      orphans.remove(item.id);
    }

    if (item.parentId == null) {
      root.add(item);
      return;
    }

    if (items.containsKey(item.parentId)) {
      items[item.parentId]!.children.add(item);
    } else {
      orphans.putIfAbsent(item.parentId!, () => {}).add(item);
    }
  }

  Future<Set<TreeItem>> getAssetTree(String companyId) async {
    final [assets, locations] = await Future.wait([
      _getAssets(companyId),
      _getLocations(companyId),
    ]);

    final Set<TreeItem> root = {};

    final Map<String, TreeItem> items = {};
    final Map<String, Set<TreeItem>> orphans = {};

    for (final location in locations) {
      final item = Location.fromJson(location as Map<String, dynamic>);
      _processItem(item, items, orphans, root);
    }

    for (final asset in assets) {
      final item = Asset.fromJson(asset as Map<String, dynamic>);
      _processItem(item, items, orphans, root);
    }

    return root;
  }
}
