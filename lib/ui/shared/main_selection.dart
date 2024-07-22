import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/providers/patient.dart';
import 'package:docsheli/ui/shared/on_board/doctor_onboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'globals/global_classes.dart';
import 'globals/global_variables.dart';
import 'on_board/patient_onboard.dart';

class MainSelection extends StatefulWidget {
  @override
  _MainSelectionState createState() => _MainSelectionState();
}

class _MainSelectionState extends State<MainSelection> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
      Provider.of<PatientProvider>(context, listen: false).getSpeciality();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Get.width * .04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppConfig.images.logo,
              scale: 3,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "CONTINUE AS",
              style: AppConfig.textStyle.poppins().copyWith(
                  color: AppConfig.colors.themeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: Get.width * .05),
            ),
            SizedBox(
              height: 20,
            ),
            GlobalButton(
                onTap: () {
                  isDoctor = true;
                  Get.offAll(() => DoctorOnBoarding());
                },
                btnColor: AppConfig.colors.themeColor,
                btnTextColor: Colors.white,
                buttonText: "DOCTOR"),
            SizedBox(
              height: 5,
            ),
            GlobalButton(
                onTap: () {
                  isDoctor = false;
                  Get.offAll(() => PatientOnBoarding());
                  // Get.offAll(() => DashBoardPatient());
                },
                btnColor: AppConfig.colors.themeColor,
                btnTextColor: Colors.white,
                buttonText: "PATIENT"),
          ],
        ),
      ),
    );
  }
}
