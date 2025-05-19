
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';
import 'package:xverifydemoapp/core/models/dashboard_item.dart';

import '../../../channels/native_channel_manager.dart';
import '../../../core/constants/colors.dart';
import '../../../core/manager/onboard_mananger.dart';

class ItemDashboard extends StatelessWidget {
  final DashboardItem item;
  const ItemDashboard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      width: (MediaQuery.sizeOf(context).width - 52) / 4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: Colors.grey.withOpacity(0.1)),
      ),
      child: GestureDetector(
        onTap: () {
          OnboardManager.instance.businessType = item.businessType;
          sendBusinessTypeToNative();
          Get.toNamed(item.route);
        },
        child: Column(
          // ✅ Đổi từ Flex thành Column
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Wrap content vertically
          children: [
            const SizedBox(height: 15),
            SvgPicture.asset(item.icon, height: 45),
            const SizedBox(height: 6),
            Expanded(
              // Đặt Expanded để chiếm không gian còn lại
              child: SizedBox(
                height: 32,
                child: Text(
                  item.title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: boldTextStyle(13, BrandColors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
