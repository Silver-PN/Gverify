import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';
import 'package:xverifydemoapp/core/manager/onboard_mananger.dart';

import 'package:xverifydemoapp/core/models/preview_document_model.dart';
import 'package:xverifydemoapp/presentation/ekyb/controller/ekyb_controller.dart';

import '../widgets/custom_button.dart';

class EkybTabResultView extends StatefulWidget{
  const EkybTabResultView({super.key});

  @override
  State<EkybTabResultView> createState() => _EkybTabResultViewState();
}

class _EkybTabResultViewState extends State<EkybTabResultView> with AutomaticKeepAliveClientMixin{
  final EkybController _controller = Get.find<EkybController>();
  @override
  bool get wantKeepAlive => true;

  Widget _displayResult() {
    TaxCodeVerifyResponse taxCode = _controller.taxCodeVerifyResponse!;
    final isValid = taxCode.isTaxCodeValid &&
        taxCode.status == "verified" &&
        OnboardManager.instance.personOptionalDetails?.eidNumber ==
            taxCode.companyRepresentativeId;
    final result = isValid?"XÁC THỰC THÀNH CÔNG": "XÁC THỰC KHÔNG THÀNH CÔNG";
    return Text(
      result,
      style: boldTextStyle(18, Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _displayResult(),
            ),
            SizedBox(height: 20),
            showDocumentfield("Mã số thuế",
                _controller.taxCodeVerifyResponse?.taxCode ?? ""),
            SizedBox(
              height: 8,
            ),
            showDocumentfield("Tên chi nhánh",
                _controller.taxCodeVerifyResponse?.name ?? ""),
            SizedBox(
              height: 8,
            ),
            showDocumentfield(
                "Số điện thoại",
                _controller.taxCodeVerifyResponse?.phoneNumber ??
                    ""),
            SizedBox(
              height: 8,
            ),
            showDocumentfield(
                "Địa chỉ",
                _controller.taxCodeVerifyResponse?.companyAddress ??
                    ""),
            SizedBox(
              height: 8,
            ),
            showDocumentfield(
                "Trạng thái",
                _controller.taxCodeVerifyResponse?.businessStatus ??
                    ""),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey[500], // Màu của đường kẻ
                    thickness: 1, // Độ dày đường kẻ
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Thông tin người đại diện",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // Màu chữ
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey[500],
                    thickness: 1,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            showDocumentfield("CMND/CCCD",
                OnboardManager.instance.personOptionalDetails!.eidNumber ?? ""),
            SizedBox(
              height: 8,
            ),
            showDocumentfield("Tên người đại diện",
                OnboardManager.instance.personOptionalDetails!.fullName ?? ""),
            SizedBox(
              height: 8,
            ),
            showDocumentfield(
                "Ngày sinh",
                OnboardManager.instance.personOptionalDetails!.dateOfBirth ??
                    ""),
            SizedBox(
              height: 8,
            ),
            showDocumentfield(
                "Ngày cấp",
                OnboardManager.instance.personOptionalDetails!.dateOfIssue ??
                    ""),
            SizedBox(
              height: 8,
            ),
            showDocumentfield(
                "Địa chỉ",
                OnboardManager
                    .instance.personOptionalDetails!.placeOfResidence ??
                    ""),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey[500], // Màu của đường kẻ
                    thickness: 1, // Độ dày đường kẻ
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Thẩm định",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // Màu chữ
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey[500],
                    thickness: 1,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            verificationStatus(),
            SizedBox(
              height: 20,
            ),
            CustomButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                content: "XONG"),
            if(Platform.isIOS)
              SizedBox(
                height: 28,
              ),
          ],
        ),
      ),
    );
  }

  Widget showDocumentfield(String fieldContent, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldContent,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white, // Màu chữ tiêu đề
          ),
        ),
        const SizedBox(height: 4), // Khoảng cách giữa tiêu đề và ô nhập
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF696774), // Màu nền xám
            borderRadius: BorderRadius.circular(8), // Bo góc
          ),
          child: Text(
            data,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white, // Màu chữ trong ô nhập
            ),
          ),
        ),
      ],
    );
  }

  Widget verificationStatus() {

    TaxCodeVerifyResponse taxCode = _controller.taxCodeVerifyResponse!;
    final isValidTaxCode = taxCode.isTaxCodeValid &&
        taxCode.status == "verified";
    var isValid = isValidTaxCode &&
        OnboardManager.instance.personOptionalDetails?.eidNumber ==
            taxCode.companyRepresentativeId && OnboardManager.instance.isFaceMatch!&&OnboardManager.instance.isValidIdCard!;


    List<Map<String, dynamic>> statuses = [
      {"label": "Xác thực CCCD", "status": OnboardManager.instance.isValidIdCard!},
      {"label": "Face Matching", "status": OnboardManager.instance.isFaceMatch!},
      {"label": "Xác thực MST", "status": isValidTaxCode},
      {"label": "Xác thực người đại diện", "status": isValid},
    ];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF696774),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: statuses.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item["label"],
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Icon(
                  item["status"] ? Icons.check_circle : Icons.cancel,
                  color: item["status"] ? Colors.green : Colors.red,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}



