import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/controllers.dart';
import '../../../models/models.dart';
import '../../../styles/styles.dart';
import 'widgets.dart';

class TreeView extends StatefulWidget {
  const TreeView({super.key});

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  final AssetTreeController controller = Get.find();

  TreeNode<TreeItem> root = TreeNode<TreeItem>.root();

  @override
  void initState() {
    super.initState();
    root = controller.tree.value!;

    controller.tree.listen((tree) {
      if (tree != null) {
        setState(() {
          root = tree;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverTreeView.simpleTyped<TreeItem, TreeNode<TreeItem>>(
      tree: root,
      expansionIndicatorBuilder: noExpansionIndicatorBuilder,
      showRootNode: false,
      indentation: const Indentation(
        style: IndentStyle.squareJoint,
        color: AppColors.gray200,
      ),
      builder: (context, item) {
        return TreeNodeItem(node: item);
      },
    );
  }
}
