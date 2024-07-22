import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docsheli/Services/shared/firestorage_service.dart';
import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/modal/medical_record.dart';
import 'package:docsheli/providers/auth.dart';
import 'package:docsheli/providers/patient.dart';
import 'package:docsheli/ui/doctor/patient_medical_record.dart';
import 'package:docsheli/ui/shared/globals/global_classes.dart';
import 'package:docsheli/ui/shared/globals/global_variables.dart';
import 'package:docsheli/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MedicalRecord extends StatelessWidget {
  File? image;
  final FStorageServices fs = FStorageServices();
  MedicalRecordModal? medicalRecord;

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProvider>(builder: (context, model, _) {
      return Scaffold(
        backgroundColor: AppConfig.colors.backGround,
        appBar: isDoctor
            ? AppBar(
                backgroundColor: AppConfig.colors.themeColor,
                leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios_outlined),
                ),
                title: Center(
                  child: Text(
                    'Patient Medical Records',
                    style: GoogleFonts.roboto(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : PreferredSize(
                child: Container(),
                preferredSize: Size.fromHeight(0),
              ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: Get.height * .04,
              // ),
              Center(
                child: Container(
                  height: Get.height * 0.68,
                  width: Get.width,
                  child: ListView(
                    children:
                        List.generate(model.medicalRecordList.length, (index) {
                      MedicalRecordModal recordData =
                          model.medicalRecordList[index];
                      return record(recordData);
                    }),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10, horizontal: Get.width * .03),
                  height: 45,
                  child: GlobalButton(
                      onTap: () {
                        _showPicker(context, model);
                      },
                      btnColor: AppConfig.colors.themeColor,
                      btnTextColor: Colors.white,
                      buttonText: "Add New Medical Record"),
                ),
              ),
            ]),
      );
    });
  }

  Widget record(MedicalRecordModal medicalRecordData) {
    return Container(
      width: Get.width,
      height: Get.height * 0.36,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(Get.height * 0.02),
            child: Text(
              '${"${DateFormat('yyyy').format(medicalRecordData.addedAt!.toDate())}"}',
              style: GoogleFonts.roboto(
                fontSize: 18.0,
                color: const Color(0xFF1C1C1C),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // SizedBox(height: Get.height * 0.02),
          Stack(
            children: [
              Center(
                child: Container(
                    color: Colors.white,
                    height: Get.height * 0.25,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: Get.width * 0.2,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppConfig.colors.cardBackGround,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.zero,
                              topRight: Radius.circular(18.0),
                              bottomLeft: Radius.zero,
                              bottomRight: Radius.circular(18.0),
                            ),
                          ),
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                style: GoogleFonts.roboto(
                                  fontSize: 20.0,
                                  color: const Color(0xFF1C1C1C),
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '${"${DateFormat('dd').format(medicalRecordData.addedAt!.toDate())}"} \n',
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${"${DateFormat('MMMM').format(medicalRecordData.addedAt!.toDate())}"}',
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            recordData(
                                0,
                                "Prescription",
                                AppConfig.images.prescription,
                                medicalRecordData),
                            SizedBox(height: Get.height * 0.015),
                            recordData(1, "Added by You.",
                                AppConfig.images.addedBy, medicalRecordData),
                            SizedBox(height: Get.height * 0.015),
                            recordData(2, "${medicalRecordData.userName}",
                                AppConfig.images.person, medicalRecordData),
                            SizedBox(height: Get.height * 0.015),
                            recordData(3, "Open", AppConfig.images.open,
                                medicalRecordData),
                          ],
                        )
                      ],
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget recordData(int index, String title, String icon,
      MedicalRecordModal medicalRecordData) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: Get.width * 0.1),
          Image.asset(
            icon,
            height: Get.height * 0.025,
            // width: Get.height * 0.025,
            fit: BoxFit.fitHeight,
            color: Colors.black,
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: index == 3
                ? () {
                    Get.dialog(ImageDialog(medicalRecordData.fileUrl!));
                  }
                : () {
                    print("not image");
                  },
            child: Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: index == 2 || index == 3 ? 20 : 16.0,
                color: const Color(0xFF1C1C1C),
                fontWeight: index == 2 || index == 3
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ),
        ]);
  }

  _imgFromCamera(PatientProvider model) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      onPickedImage(image, model);
    }
  }

  _imgFromGallery(PatientProvider model) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      onPickedImage(image, model);
    }
  }

  Future onPickedImage(file, PatientProvider model) async {
    final appUser =
        Provider.of<AuthProvider>(Get.context!, listen: false).appUser!;
    medicalRecord?.userId = "${appUser.phone}";
    medicalRecord?.fileCount = 1;
    medicalRecord?.addedAt = Timestamp.now();
    medicalRecord?.userName = "${appUser.name}";

    if (file == null) {
      return;
    }
    try {
      model.startLoader();
      String imageUrl = await fs.uploadSingleFile(
          bucketName: FsBuckets.medicalRecordImage,
          file: file,
          userId: medicalRecord!.userId!);
      medicalRecord?.fileUrl = imageUrl;
      if (medicalRecord != null) {
        await model.addMedicalRecord(medicalRecord: medicalRecord!);
      }
    } catch (e) {
      model.stopLoader();
    }
  }

  void _showPicker(context, PatientProvider model) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Add a record',
                      style: GoogleFonts.roboto(
                        fontSize: 14.0,
                        color: const Color(0xFF1C1C1C).withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  new ListTile(
                    leading: new Icon(
                      Icons.camera_alt_sharp,
                      color: Colors.black,
                    ),
                    title: new Text('Take a Photo'),
                    onTap: () {
                      _imgFromCamera(model);
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                      leading:
                          new Icon(Icons.photo_library, color: Colors.black),
                      title: new Text('Select From Gallery'),
                      onTap: () {
                        _imgFromGallery(model);
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        });
  }
}
