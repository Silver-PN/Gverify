import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/generated/assets.gen.dart';




class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: BrandColors.primary,
      toolbarHeight: 80,
      leading: const BackButton(color: Colors.white),
      title: Assets.icons.icLogoGtel.svg(height: 26, color: Colors.white),
      centerTitle: true,
    );
  }
}
