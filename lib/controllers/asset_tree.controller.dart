import 'dart:async';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/tree_view/tree_node.dart';
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

  Set<TreeItem> base = {};
  final Rx<TreeNode<TreeItem>?> tree = Rx(null);
  final RxBool isLoading = true.obs;

  final TreeFilter filters = TreeFilter();

  TreeNode<TreeItem>? _filterNode(TreeItem item) {
    final newNode = TreeNode(data: item, key: item.id);
    bool result = false;

    if (filters.matches(item)) {
      result = true;
    }

    for (final child in item.children) {
      final filtered = _filterNode(child);

      if (filtered != null) {
        newNode.add(filtered);
        result = true;
      }
    }

    return result ? newNode : null;
  }

  void processFilters() {
    final filtered = TreeNode<TreeItem>.root();

    for (final item in base) {
      final filteredChild = _filterNode(item);

      if (filteredChild != null) {
        filtered.add(filteredChild);
      }
    }

    tree.value = filtered;
    tree.trigger(filtered);
  }

  void _processItem(
    TreeItem item,
    Map<String, TreeNode<TreeItem>> items,
    Map<String, Set<TreeNode<TreeItem>>> orphans,
    TreeNode<TreeItem> root,
    Set<TreeItem> base,
  ) {
    final node = TreeNode(data: item, key: item.id);
    items[item.id] = node;

    if (orphans.containsKey(item.id)) {
      for (final item in orphans[item.id]!) {
        node.add(item);
        node.data!.children.add(item.data!);
      }

      orphans.remove(item.id);
    }

    if (item.parentId == null) {
      root.add(node);
      base.add(item);
      return;
    }

    if (items.containsKey(item.parentId)) {
      items[item.parentId]!.add(node);
      items[item.parentId]!.data!.children.add(item);
    } else {
      orphans.putIfAbsent(item.parentId!, () => {}).add(node);
    }
  }

  Future<void> _buildTree(String companyId) async {
    final [assets, locations] = await Future.wait([
      _service.getAssets(companyId),
      _service.getLocations(companyId),
    ]);

    final root = TreeNode<TreeItem>.root();
    final base = <TreeItem>{};

    final Map<String, TreeNode<TreeItem>> items = {};
    final Map<String, Set<TreeNode<TreeItem>>> orphans = {};

    for (final location in locations) {
      final item = Location.fromJson(location as Map<String, dynamic>);
      _processItem(item, items, orphans, root, base);
    }

    for (final asset in assets) {
      final item = Asset.fromJson(asset as Map<String, dynamic>);
      _processItem(item, items, orphans, root, base);
    }

    this.base = base;
    tree.value = root;
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
