import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../styles/styles.dart';

class TreeNodeItem extends StatefulWidget {
  final TreeItem item;
  final double indent;

  const TreeNodeItem({super.key, required this.item, this.indent = 0});

  @override
  State<TreeNodeItem> createState() => _TreeNodeItemState();
}

class _TreeNodeItemState extends State<TreeNodeItem> {
  bool isOpen = false;

  TreeItem get item => widget.item;

  @override
  Widget build(BuildContext context) {
    Widget? sensor;

    if (item is Component) {
      final component = item as Component;

      sensor = Icon(
        component.sensorType.icon,
        color: component.sensorStatus.color,
        size: component.sensorType.icon == Icons.circle ? 12 : 20,
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: widget.indent),
      child: Column(
        children: [
          InkWell(
            splashFactory: NoSplash.splashFactory,
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Row(
                children: [
                  if (item.children.isNotEmpty) ...[
                    AnimatedRotation(
                      turns: isOpen ? 0.25 : 0,
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOutQuint,
                      child: const Icon(
                        Icons.chevron_right,
                      ),
                    ),
                  ],
                  const SizedBox(width: 6),
                  SvgPicture.asset(item.icon, width: 20, height: 20),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          item.name,
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
            ),
          ),
          if (isOpen) ...[
            for (final child in item.visibleChildren)
              TreeNodeItem(
                item: child,
                indent: child.children.isNotEmpty ? 16 : 22,
              ),
          ],
        ],
      ),
    );
  }
}
