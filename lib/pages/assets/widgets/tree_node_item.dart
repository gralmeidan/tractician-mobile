import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../styles/styles.dart';

class TreeNodeItem extends StatelessWidget {
  final TreeNode<TreeItem> node;

  const TreeNodeItem({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    if (node.data == null) {
      return const SizedBox();
    }

    Widget? sensor;

    if (node.data! is Component) {
      final component = node.data! as Component;

      sensor = Icon(
        component.sensorType.icon,
        color: component.sensorStatus.color,
        size: component.sensorType.icon == Icons.circle ? 12 : 20,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          if (!node.isLeaf) ...[
            ChevronIndicator.rightDown(tree: node),
            const SizedBox(width: 6),
          ] else
            const SizedBox(width: 5),
          SvgPicture.asset(node.data!.icon, width: 20, height: 20),
          const SizedBox(width: 6),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  node.data!.name,
                  style: AppTextStyles.labelMedium,
                ),
                if (sensor != null) ...[
                  const SizedBox(width: 8),
                  sensor,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
