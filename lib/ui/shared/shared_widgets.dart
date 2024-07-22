import 'package:docsheli/providers/auth.dart';
import 'package:docsheli/ui/doctor/semiDashBoardDoc.dart';
import 'package:docsheli/ui/patient/semi_dashbooard.dart';
import 'package:docsheli/ui/sign_up/doctor_signup.dart';
import 'package:docsheli/ui/sign_up/patient_signup.dart';
import 'package:docsheli/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'globals/confirmation_dialog.dart';
import 'globals/global_variables.dart';
import 'main_selection.dart';

class SharedWidgets {
  static Widget drawerItem(int index, String title, img) {
    return GestureDetector(
      onTap: () async {
        switch (index) {
          case 0:
            {
              Get.back();
              isDoctor ? Get.to(SemiDashBoardDoc(1)) : Get.to(SemiDashBoard(1));

              break;
            }
          case 1:
            {
              Get.back();
              Get.to(SemiDashBoard(2));
              break;
            }
          case 2:
            {
              Get.back();
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
                      profileData:
                          Provider.of<AuthProvider>(Get.context!, listen: false)
                              .appUser!,
                    ));

              break;
            }
          case 3:
            {
              Get.back();

              break;
            }
          case 4:
            {
              var res = await Get.bottomSheet(ConfirmationDialog(
                title: "Are you sure?",
                body: "You will be redirected to login page",
                buttonName: "Ok",
              ));

              if (res) {
                Provider.of<AuthProvider>(Get.context!, listen: false)
                    .signOut();
                AppRoutes.makeFirst(Get.context!, MainSelection());
              }

              break;
            }
          case 5:
            {
              Get.back();
              Get.offAll(MainSelection());

              break;
            }
        }
      },
      child: Container(
          color: Colors.white,
          margin: EdgeInsets.symmetric(
              vertical: Get.height * .01, horizontal: Get.width * .06),
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.01),
              Row(
                children: [
                  Container(
                    height: 25,
                    width: 25,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(3)),
                    child: Image.asset(
                      img,
                      // color: index == 5 ? null : whiteColor,
                      // scale: index == 4
                      //     ? 4
                      //     : index == 5
                      //         ? 2.5
                      //         : 3,
                    ),
                  ),
                  SizedBox(
                    width: Get.width * .02,
                  ),
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 16.0,
                      color: const Color(0xFF1C1C1C).withOpacity(0.6),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: Get.height * 0.01),
            ],
          )),
    );
  }
}
