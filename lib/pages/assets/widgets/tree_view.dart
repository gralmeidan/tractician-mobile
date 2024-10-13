import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/controllers.dart';
import '../../../models/models.dart';
import 'widgets.dart';

class TreeView extends StatefulWidget {
  const TreeView({super.key});

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  final AssetTreeController controller = Get.find();

  Set<TreeItem> root = RxSet();

  @override
  void initState() {
    super.initState();
    root = controller.root;

    controller.root.listen((tree) {
      setState(() {
        root = tree;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: controller.root.length,
      itemBuilder: (context, index) {
        final item = controller.root.elementAt(index);
        return TreeNodeItem(item: item);
      },
    );
  }
}
