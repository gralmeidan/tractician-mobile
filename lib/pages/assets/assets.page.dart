import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_bar.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';
import 'widgets/widgets.dart';

class AssetsPage extends GetView<AssetTreeController> {
  const AssetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'Assets'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverTreeView.simpleTyped<TreeItem, TreeNode<TreeItem>>(
                tree: controller.tree.value!,
                expansionIndicatorBuilder: noExpansionIndicatorBuilder,
                showRootNode: false,
                indentation: const Indentation(
                  style: IndentStyle.squareJoint,
                ),
                builder: (context, item) {
                  return TreeNodeItem(node: item);
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
