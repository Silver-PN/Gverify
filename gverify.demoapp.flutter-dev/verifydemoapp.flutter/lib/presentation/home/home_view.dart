import 'package:flutter/material.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/generated/assets.gen.dart';
import 'package:xverifydemoapp/presentation/home/widget/item_dashboard.dart';

import '../../core/models/dashboard_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.primary,
      appBar: AppBar(
        backgroundColor: BrandColors.primary,
        title: Assets.icons.icLogoGtel.svg(height: 26, color: Colors.white),
        centerTitle: true,
      ),
      body: SafeArea(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: DashboardManager.lists.length,
              itemBuilder: (context, index) {
                return ItemDashboard(
                  item: DashboardManager.lists[index],
                );
              })),
    );
  }
}
