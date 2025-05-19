
import 'package:xverifydemoapp/app_router.dart';
import 'package:xverifydemoapp/generated/assets.gen.dart';

import '../manager/onboard_mananger.dart';

class DashboardItem{
   String icon;
   String title;
   String route;
   BusinessType businessType;

   DashboardItem(this.icon,this.title,this.route,this.businessType);
}

class DashboardManager{
  static List<DashboardItem> lists = [
    DashboardItem(Assets.icons.icNfc.path, 'CCCD', AppRouters.verifyEid, BusinessType.VERIFY_EID),
    DashboardItem(Assets.icons.icCard.path, 'Bio-2345', AppRouters.bio2345Main, BusinessType.VERIFY_BANK_TRANSFER),
    DashboardItem(Assets.icons.icOcr.path, 'OCR', AppRouters.captureOcr, BusinessType.VERIFY_OCR),
    DashboardItem(Assets.icons.icPeoplescan.path, 'Active EKYC', AppRouters.verifyActiveEkycMain, BusinessType.VERIFY_EID_ACTIVE_EKYC),
    DashboardItem(Assets.icons.icPeoplescan.path, 'Simple EKYC', AppRouters.verifyActiveEkycMain, BusinessType.VERIFY_EID_SIMPLE_EKYC),
    DashboardItem(Assets.icons.icNote.path, 'EKYB', AppRouters.verifyEkyb, BusinessType.VERIFY_EKYB),
  ];
}
