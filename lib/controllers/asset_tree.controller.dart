import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:get/get.dart';

import '../models/models.dart';
import '../services/services.dart';

class AssetTreeController extends GetxController {
  TracticianService get _service => TracticianService.to;

  final Rx<TreeNode<TreeItem>?> tree = Rx(null);
  final RxBool isLoading = true.obs;

  void _processItem(
    TreeItem item,
    Map<String, TreeItem> items,
    Map<String, Set<TreeItem>> orphans,
    TreeNode<TreeItem> root,
  ) {
    items[item.id] = item;

    if (orphans.containsKey(item.id)) {
      item.node.addAll(orphans[item.id]!.map((e) => e.node));
      orphans.remove(item.id);
    }

    if (item.parentId == null) {
      root.add(item.node);
      return;
    }

    if (items.containsKey(item.parentId)) {
      items[item.parentId]!.node.add(item.node);
    } else {
      orphans.putIfAbsent(item.parentId!, () => {}).add(item);
    }
  }

  Future<void> _buildTree(String companyId) async {
    final [assets, locations] = await Future.wait([
      _service.getAssets(companyId),
      _service.getLocations(companyId),
    ]);

    final root = TreeNode<TreeItem>.root();

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
  }
}
