import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../models/models.dart';
import '../services/services.dart';

class TreeFilter {
  final TextEditingController query = TextEditingController();
  final Rx<SensorType?> sensorType = Rx(null);
  final Rx<SensorStatus?> sensorStatus = Rx(null);

  void clear() {
    query.clear();
    sensorType.value = null;
    sensorStatus.value = null;
  }

  void dispose() {
    query.dispose();
    sensorType.close();
    sensorStatus.close();
  }

  bool matches(TreeItem item) {
    if (query.text.isNotEmpty && !item.name.toLowerCase().contains(query.text.toLowerCase())) {
      return false;
    }

    if (sensorType.value != null) {
      if (item is! Component || item.sensorType != sensorType.value) {
        return false;
      }
    }

    if (sensorStatus.value != null) {
      if (item is! Component || item.sensorStatus != sensorStatus.value) {
        return false;
      }
    }

    return true;
  }
}

class AssetTreeController extends GetxController {
  TracticianService get _service => TracticianService.to;

  RxSet<TreeItem> base = RxSet();
  RxSet<TreeItem> root = RxSet();
  final RxBool isLoading = true.obs;

  final TreeFilter filters = TreeFilter();

  TreeItem? _filterNode(TreeItem item) {
    bool result = false;

    if (filters.matches(item)) {
      result = true;
    }

    for (final child in item.children) {
      final filtered = _filterNode(child);

      if (filtered != null) {
        result = true;
      }
    }

    item.visible = result;

    return result ? item : null;
  }

  void processFilters() {
    final filtered = <TreeItem>{};

    for (final item in base) {
      final filteredChild = _filterNode(item);

      if (filteredChild != null) {
        filtered.add(filteredChild);
      }
    }

    root.assignAll(filtered);
    root.refresh();
  }

  void _processItem(
    TreeItem item,
    Map<String, TreeItem> items,
    Map<String, Set<TreeItem>> orphans,
    Set<TreeItem> root,
  ) {
    items[item.id] = item;

    if (orphans.containsKey(item.id)) {
      for (final child in orphans[item.id]!) {
        items[item.id]!.children.add(child);
      }

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

  Future<void> _buildTree(String companyId) async {
    final [assets, locations] = await Future.wait([
      _service.getAssets(companyId),
      _service.getLocations(companyId),
    ]);

    final root = <TreeItem>{};

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

    base.assignAll(root);
    this.root.assignAll(root);
  }

  Future<void> _fetchTree() async {
    isLoading.value = true;

    try {
      final company = Get.arguments as Company;

      await _buildTree(company.id);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _fetchTree();

    filters.query.addListener(processFilters);
    filters.sensorType.listen((_) => processFilters());
    filters.sensorStatus.listen((_) => processFilters());
  }

  @override
  void onClose() {
    super.onClose();
    filters.dispose();
  }
}
