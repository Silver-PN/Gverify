
import 'package:flutter/material.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';

import '../../../generated/fonts.gen.dart';


class OcrVerifySuccessInfoRow extends StatelessWidget {
  String title;
  String content;

  OcrVerifySuccessInfoRow({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              child: Text(
                title,
                style:  mediumTextStyle(15,  BrandColors.gray),
              ),
            ),
            Expanded(
              child: Text(
                content,
                style:  TextStyle(
                    fontFamily: FontFamily.googleSansBold,
                    color: BrandColors.colorTextOnSecondary,
                    fontSize: 16),
                maxLines: null, // Cho phép text xuống dòng tự do
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}