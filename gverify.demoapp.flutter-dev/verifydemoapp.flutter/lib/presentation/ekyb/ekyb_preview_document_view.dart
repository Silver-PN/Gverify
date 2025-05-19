

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xverifydemoapp/core/models/document_type.dart';
import 'package:xverifydemoapp/core/models/preview_document_model.dart';
import 'package:xverifydemoapp/presentation/ekyb/controller/ekyb_controller.dart';

import '../../app_router.dart';
import '../../core/constants/colors.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';

class EkybPreviewDocumentView extends StatelessWidget {
   EkybPreviewDocumentView({super.key});

  final EkybController _controller = Get.find<EkybController>();

  @override
  Widget build(BuildContext context) {
    PreviewDocumentModel preview = _controller.previewDocumentModel!;
    return Scaffold(
      appBar: const CustomAppbar(),
      backgroundColor: BrandColors.primary,
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(preview.typeDocument??"",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
                    const SizedBox(height: 20,),
                    showDocumentField("Loại giấy tờ",preview!.textType!),
                    const SizedBox(height: 8,),
                    showDocumentField("Mã số thuế",preview.taxcode??""),
                    const SizedBox(height: 8,),
                    showDocumentField("Tên doanh nghiệp",preview.businessName??""),
                    const SizedBox(height: 8,),
                    showDocumentField("Số điện thoại",preview.phoneNumber??""),
                    const SizedBox(height: 8,),
                    showDocumentField("Địa chỉ",preview.address??""),
                    const SizedBox(height: 8,),
                    showDocumentField("Nơi phát hành",preview.placeOfIssue??""),
                    const SizedBox(height: 8,),
                    showDocumentField("Người ký tên",preview.signer??""),
                    const SizedBox(height: 12,),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey[500], // Màu của đường kẻ
                            thickness: 1, // Độ dày đường kẻ
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Thông tin người đại diện",
                            style: const TextStyle(
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
                    const SizedBox(height: 12,),
                    showDocumentField("CMND/CCCD",preview.representativeModel?.eId??""),
                    const SizedBox(height: 8,),
                    showDocumentField("Tên người đại diện",preview.representativeModel?.fullName??""),
                    const SizedBox(height: 8,),
                    showDocumentField("Ngày sinh",preview.representativeModel?.dateOfBirth??""),
                    const SizedBox(height: 8,),
                    showDocumentField("Ngày cấp",preview.representativeModel?.dateOfIssue??""),
                    const SizedBox(height: 8,),
                    showDocumentField("Địa chỉ",preview.representativeModel?.address??""),
                  ],
                ),
              ),
            ),
            const SizedBox( height: 12,),

            CustomButton(onPressed: (){
              Navigator.pushNamed(context, AppRouters.captureOcr,);
            }, content: "Tiếp tục"),

          ],
        ),
      )),
    );
  }


   Widget showDocumentField(String fieldContent,String data){
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text(
           fieldContent,
           style:const TextStyle(
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
}
