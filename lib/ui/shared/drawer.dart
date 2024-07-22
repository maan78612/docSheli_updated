import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/ui/shared/shared_widgets.dart';
import 'package:docsheli/utils/app_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'globals/global_variables.dart';

class DrawerCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: Get.height * .3,
            child: DrawerHeader(
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircularProfileAvatar(
                        "",
                        child: AppUser.user?.imageUrl == null ||
                                (AppUser.user?.imageUrl ?? "").isEmpty
                            ? Image.asset(
                                isDoctor
                                    ? AppConfig.images.doc2
                                    : AppConfig.images.addImgIcon,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                AppUser.user!.imageUrl!,
                                fit: BoxFit.cover,
                              ),
                        borderWidth: 1,
                        radius: Get.width * 0.1,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppUser.user?.name ?? "",
                            style: GoogleFonts.lato(
                              fontSize: 18.0,
                              color: const Color(0xFF2A2AC0),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            AppUser.user?.phone ?? "",
                            style: GoogleFonts.lato(
                              fontSize: 15.0,
                              color: const Color(0xFF181461),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )),
            ),
          ),
          Container(
            color: Colors.white,
            height: Get.height * .68,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SharedWidgets.drawerItem(
                  0,
                  isDoctor ? "Patients Appointments" : "My Appointments",
                  AppConfig.images.myAppointments,
                ),
                isDoctor
                    ? SizedBox()
                    : SharedWidgets.drawerItem(
                        1, "Medical Records", AppConfig.images.medicalReport),
                SharedWidgets.drawerItem(
                    2, "Account Settings", AppConfig.images.profile),
                SharedWidgets.drawerItem(3, "Help", AppConfig.images.help),
                SharedWidgets.drawerItem(4, "Logout", AppConfig.images.logout),
                Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
