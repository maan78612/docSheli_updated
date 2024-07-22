import 'dart:io';

import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/providers/auth.dart';
import 'package:docsheli/providers/doctor.dart';
import 'package:docsheli/providers/patient.dart';
import 'package:docsheli/ui/doctor/semiDashBoardDoc.dart';
import 'package:docsheli/ui/patient/semi_dashbooard.dart';
import 'package:docsheli/ui/shared/drawer.dart';
import 'package:docsheli/ui/shared/globals/confirmation_dialog.dart';
import 'package:docsheli/ui/shared/globals/global_variables.dart';
import 'package:docsheli/ui/sign_up/doctor_signup.dart';
import 'package:docsheli/ui/sign_up/patient_signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashBoardPatient extends StatefulWidget {
  @override
  _DashBoardPatientState createState() => _DashBoardPatientState();
}

class _DashBoardPatientState extends State<DashBoardPatient> {
  var scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
      Provider.of<PatientProvider>(context, listen: false).onInItDashBoard();
    });
    DoctorProvider p = Provider.of<DoctorProvider>(context, listen: false);

    p.getAllDoctors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var res = await Get.bottomSheet(ConfirmationDialog(
          title: "Are you sure?",
          body: "Tap Yes to close the app",
          buttonName: "Yes",
        ));

        if (res) {
          exit(0);
        }
        return Future.value(false);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppConfig.colors.backGround,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(125),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        scaffoldKey.currentState?.openDrawer();
                      },
                      icon: Image.asset(
                        AppConfig.images.drawerImg,
                        scale: 3.5,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        isDoctor
                            ? Get.to(DoctorSignUp(
                                appBarTitle: "Account Settings",
                                subTitle: "Profile",
                                isEditProfile: true,
                              ))
                            : Get.to(PatientSignUp(
                                appBarTitle: "Account Settings",
                                subTitle: "Profile",
                                isProfile: true,
                                profileData: Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .appUser!,
                              ));
                        print("profile image");
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          AppConfig.images.profile,
                          scale: 3.5,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  'Dashboard',
                  style: GoogleFonts.lato(
                    fontSize: 26.0,
                    color: const Color(0xFF181461),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: DrawerCustom(),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.025),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 1,
                      child: showImagesData(
                          0, "Appointments", AppConfig.images.appointments),
                    ),
                    Expanded(
                        flex: 1,
                        child: showImagesData(
                            1,
                            isDoctor ? "Patients" : "Records",
                            isDoctor
                                ? AppConfig.images.patientMainImg
                                : AppConfig.images.record)),
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.01),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        flex: 1,
                        child: showImagesData(
                            2,
                            isDoctor ? "Consults Other Doctor" : "Doctors",
                            isDoctor
                                ? AppConfig.images.doctorMainImg
                                : AppConfig.images.doctor)),
                    Expanded(
                      flex: 1,
                      child: showImagesData(3, "Account Settings",
                          AppConfig.images.accountSetting),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showImagesData(int index, String title, String image) {
    // print("\n\n\n\n this is Status ${formImageStatus.toString()}");
    return GestureDetector(
      onTap: () {
        // index==0?
        if (index == 2)
          isDoctor ? Get.to(SemiDashBoardDoc(2)) : Get.to(SemiDashBoard(0));
        if (index == 3)
          isDoctor
              ? Get.to(DoctorSignUp(
                  appBarTitle: "Account Settings",
                  subTitle: "Profile",
                  isEditProfile: true,
                ))
              : Get.to(PatientSignUp(
                  appBarTitle: "Account Settings",
                  subTitle: "Profile",
                  isProfile: true,
                  profileData: Provider.of<AuthProvider>(context, listen: false)
                      .appUser!,
                ));
        if (index == 0)
          isDoctor ? Get.to(SemiDashBoardDoc(0)) : Get.to(SemiDashBoard(1));
        if (index == 1)
          isDoctor ? Get.to(SemiDashBoardDoc(1)) : Get.to(SemiDashBoard(2));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Get.width * 0.03, vertical: Get.height * 0.01),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(.30),
                  spreadRadius: 3,
                  blurRadius: 2)
            ]),
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.01, vertical: Get.height * 0.02),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text(
            '$title',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: Get.width * .045,
              color: const Color(0xFF181461),
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.03, vertical: Get.height * 0.02),
            child: Container(
              height: Get.width * .3,
              child: Image.asset(
                image,
                // height: 81,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
