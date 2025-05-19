
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xverifydemoapp/core/constants/colors.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';
import 'package:xverifydemoapp/core/models/document_type.dart';
import 'package:xverifydemoapp/presentation/ekyb/controller/ekyb_controller.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';

class EkybMainView extends StatefulWidget {
  const EkybMainView({super.key});

  @override
  State<EkybMainView> createState() => _EkybMainViewState();
}

class _EkybMainViewState extends State<EkybMainView> {
  final documentsType = DocumentType.values
      .map((e) => MapEntry(e.name, e.getLocalized()))
      .toList();



  final EkybController _controller = Get.put(EkybController());
  String? selectedDocumentKey;
  List<File> images = [];
  List<String> imagePaths = [];


  @override
  void initState() {
    selectedDocumentKey = documentsType.first.key;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      backgroundColor: BrandColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Vui lòng chọn loại tài liệu và upload tài liệu của bạn",
                textAlign: TextAlign.center,
                style: mediumTextStyle(18, Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                color: BrandColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedDocumentKey,
                        dropdownColor: Colors.white,
                        items: documentsType.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(
                              entry.value,
                              style: mediumTextStyle(
                                  15, Colors.black), // dropdown list = đen
                            ),
                          );
                        }).toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return documentsType.map((entry) {
                            return Text(
                              entry.value,
                              style: mediumTextStyle(
                                  14, Colors.white), // selected item = trắng
                            );
                          }).toList();
                        },
                        decoration: InputDecoration(
                          labelText: 'Loại tài liệu',
                          prefixIcon:
                              Icon(Icons.attach_file, color: Colors.white),
                          labelStyle: mediumTextStyle(15, Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        iconEnabledColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            selectedDocumentKey = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: images.length + 1,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                            if (index == 0) {
                              return _buildAddImagePreview(); // slot đầu tiên là add
                            } else {
                              return _buildImagePreview(images[index - 1], index - 1);
                            }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(onPressed: () {
                _controller.requestScanDocuments(imagePaths, selectedDocumentKey!);
              }, content: "Tiếp tục"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAddImagePreview() {
    return GestureDetector(
      onTap: () async {
        _pickImage();
      },
      child: DottedBorder(
        color: Colors.white,
        dashPattern: [6, 3],
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        child: Center(
          child: Icon(Icons.add, size: 30, color: Colors.green),
        ),
      ),
    );
  }


  Widget _buildImagePreview(File? image,int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(width: 1, color: Colors.white)
      ),
      child: Stack(
        children: [
          image != null?
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(image, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
          ):Container(),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => {_removeImage(index)},
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                padding: EdgeInsets.all(2),
                child: Icon(Icons.remove, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _removeImage(int index) {
    setState(() {
      images.removeAt(index);
      imagePaths.removeAt(index);
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        for (var file in pickedFiles) {
          images.add(File(file.path));
          imagePaths.add(file.path);
        }
      });
    }
  }


}
