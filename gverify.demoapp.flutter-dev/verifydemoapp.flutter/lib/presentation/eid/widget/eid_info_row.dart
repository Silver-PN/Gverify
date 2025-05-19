

import 'package:flutter/material.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';


class EidInformationRow extends StatelessWidget {
  String title;
  String? content;

  EidInformationRow({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: mediumTextStyle(16, BrandColors.gray),),
          Text(content != null ? content!.toUpperCase() : "",
            style: mediumTextStyle(15, BrandColors.colorTextOnSecondary)),
          const Divider(
            thickness: 0.5,
            color: BrandColors.silver,
          ),
        ],
      ),
    );
  }
}
