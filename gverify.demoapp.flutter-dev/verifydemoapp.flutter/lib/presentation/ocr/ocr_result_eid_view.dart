import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../channels/native_channel_manager.dart';
import '../../core/manager/onboard_mananger.dart';
import '../../core/models/card_type_enums.dart';
import '../eid/widget/eid_info_row.dart';
import '../widgets/custom_button.dart';


class OcrResultEidView extends StatelessWidget {
  bool? needPadding;
  OcrResultEidView({this.needPadding,super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(right: 8, left: 8, top: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: Image.file(
                        File(OnboardManager.instance.referenceFaceImagePath ?? "")),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  EidInformationRow(
                      title: "Số CCCD",
                      content:
                      OnboardManager.instance.personOptionalDetails?.eidNumber),
                  EidInformationRow(
                      title: "Họ và tên",
                      content:
                      OnboardManager.instance.personOptionalDetails?.fullName),
                  EidInformationRow(
                      title: "Giới tính",
                      content:
                      OnboardManager.instance.personOptionalDetails?.gender),
                  EidInformationRow(
                      title: "Ngày sinh",
                      content: OnboardManager
                          .instance.personOptionalDetails?.dateOfBirth),
                  EidInformationRow(
                      title: "Tuổi",
                      content:
                      "${DateTime.now().year - int.parse(OnboardManager.instance.personOptionalDetails!.dateOfBirth!.split("/")[2])}"),
                  EidInformationRow(
                      title: "Ngày cấp",
                      content: OnboardManager
                          .instance.personOptionalDetails?.dateOfIssue),
                  EidInformationRow(
                      title: "Có giá trị đến",
                      content: OnboardManager
                          .instance.personOptionalDetails?.dateOfExpiry),
                  EidInformationRow(
                      title: "Dân tộc",
                      content:
                      OnboardManager.instance.personOptionalDetails?.ethnicity),
                  EidInformationRow(
                      title: "Tôn giáo",
                      content:
                      OnboardManager.instance.personOptionalDetails?.religion),
                  EidInformationRow(
                      title: "Quê quán",
                      content: OnboardManager
                          .instance.personOptionalDetails?.placeOfOrigin),
                  EidInformationRow(
                      title: "Thường trú",
                      content: OnboardManager
                          .instance.personOptionalDetails?.placeOfResidence),
                  EidInformationRow(
                      title: "Đặc điểm nhận dạng",
                      content: OnboardManager
                          .instance.personOptionalDetails?.personalIdentification),
                  EidInformationRow(
                      title: "Tên bố",
                      content: OnboardManager
                          .instance.personOptionalDetails?.fatherName),
                  EidInformationRow(
                      title: "Tên mẹ",
                      content: OnboardManager
                          .instance.personOptionalDetails?.motherName),
                  EidInformationRow(
                      title: "Tên vợ/chồng",
                      content: OnboardManager
                          .instance.personOptionalDetails?.spouseName),
                  EidInformationRow(
                      title: "Số CMND",
                      content: OnboardManager
                          .instance.personOptionalDetails?.oldEidNumber),
                  EidInformationRow(
                      title: "Quốc tịch",
                      content: OnboardManager
                          .instance.personOptionalDetails?.nationality),
                  FutureBuilder<String>(
                    future: getCardType(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return EidInformationRow(title: "Loại thẻ", content: "Đang tải...");
                      } else if (snapshot.hasError) {
                        return EidInformationRow(title: "Loại thẻ", content: "Lỗi");
                      } else {
                        return EidInformationRow(title: "Loại thẻ", content: snapshot.data);
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: CustomButton(onPressed: (){Navigator.popUntil(context, (route) => route.isFirst);}, content: "XONG"),),
            SizedBox(height: 10,),
          ],
        ),
      )
    );
  }

  Future<String> getCardType() async{
    try {
      final  String? type = await platform.invokeMethod(GET_CARD_TYPE);
      var typeCard = CardTypeEnums.getType(type??"");
      return typeCard ?? "UNKNOWN";
    } on PlatformException catch (e) {
      print("Failed to get native message: '${e.message}'.");
      return "UNKNOWN";
    }
  }
}
