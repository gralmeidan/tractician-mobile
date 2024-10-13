import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../styles/styles.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool canPop;

  const DefaultAppBar({
    super.key,
    this.title,
    this.canPop = true,
  });

  @override
  Widget build(BuildContext context) {
    late Widget title;
    Widget? leading;

    if (this.title != null) {
      title = Text(
        this.title!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      );
    } else {
      title = SvgPicture.asset(
        AppIcons.logo,
        height: 17,
      );
    }

    if (canPop) {
      leading = Padding(
        padding: const EdgeInsets.only(left: 16),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }

    return AppBar(
      backgroundColor: AppColors.appBar,
      title: title,
      leading: leading,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
