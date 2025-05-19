
import 'package:flutter/material.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';


class InfoEkycRow extends StatelessWidget {
  final String title;
  final String? content;
  final bool? isSuccess;

  InfoEkycRow({
    super.key,
    required this.title,
    this.content,
    this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              title,
              style:  mediumTextStyle(15, BrandColors.gray),
            ),
          ),
          content != null
              ? Expanded(
            child: Text(
              content!,
              style: boldTextStyle(15, BrandColors.colorTextOnSecondary),
              maxLines: null, // Cho phép text xuống dòng tự do
            ),
          )
              : Icon(
            isSuccess == true ? Icons.check_circle : Icons.cancel,
            size: 24,
            color:
            isSuccess == true ? BrandColors.success : BrandColors.failed,
          ),
        ],
      ),
    );
  }
}