import 'dart:io';

import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/modal/medical_record.dart';
import 'package:docsheli/providers/patient.dart';
import 'package:docsheli/ui/shared/globals/global_classes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PatientMedicalRecord extends StatelessWidget {
   File? image;

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProvider>(builder: (context, model, _) {
      return Scaffold(
        backgroundColor: AppConfig.colors.backGround,
        appBar: AppBar(
          backgroundColor: AppConfig.colors.themeColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            iconSize: 18,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            "Patient Medical Records",
            style: AppConfig.textStyle.poppins().copyWith(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height * .04,
              ),
              Center(
                child: Container(
                  height: Get.height * 0.68,
                  width: Get.width,
                  child: ListView(
                    children: List.generate(
                        model.medicalRecordList.length, (index) {
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
                        Get.back();
                      },
                      btnColor: AppConfig.colors.themeColor,
                      btnTextColor: Colors.white,
                      buttonText: "Close"),
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
}

class ImageDialog extends StatelessWidget {
  final String image;

  ImageDialog(this.image);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            image: DecorationImage(
                image: NetworkImage('$image'), fit: BoxFit.cover)),
      ),
    );
  }
}
