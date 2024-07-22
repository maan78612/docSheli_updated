import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/modal/appointment.dart';
import 'package:docsheli/modal/doctor_info.dart';
import 'package:docsheli/modal/user_data.dart';
import 'package:docsheli/providers/auth.dart';
import 'package:docsheli/providers/patient.dart';
import 'package:docsheli/ui/shared/shimmers/shimmers.dart';
import 'package:docsheli/utils/app_user.dart';
import 'package:docsheli/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Appointments extends StatelessWidget {
  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProvider>(builder: (context, patientProvider, _) {
      return Scaffold(
        backgroundColor: AppConfig.colors.backGround,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Get.height * .04,
                  ),
                  Center(
                    child: Container(
                      height: Get.height * 0.72,
                      width: Get.width * 0.9,
                      child: ListView(
                        children: List.generate(
                            patientProvider.getAppointmentList
                                .where((element) =>
                                    element.patientID ==
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .appUser!
                                        .phone!)
                                .toList()
                                .length, (index) {
                          AppointmentModal appointmentData = patientProvider
                              .getAppointmentList
                              .where((element) =>
                                  element.patientID ==
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .appUser!
                                      .phone)
                              .toList()[index];
                          return appointmentList(
                              appointmentData, patientProvider);
                        }),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      );
    });
  }

  Widget appointmentList(
      AppointmentModal appointmentData, PatientProvider patientProvider) {
    return FutureBuilder(
        future: patientProvider.getDoctorInfo(appointmentData.doctorId!),
        builder: (context, AsyncSnapshot<DoctorInfo> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Shimmers.general();

            case ConnectionState.waiting:
              return Shimmers.general();

            case ConnectionState.active:
              return Shimmers.general();

            case ConnectionState.done:
              DoctorInfo docData = snapshot.data!;

              return FutureBuilder(
                  future: docData.userRef?.get(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> userSnap) {
                    if (!userSnap.hasData) {
                      return Shimmers.general();
                    } else {
                      UserData docInfo =
                          UserData.fromJson(userSnap.data?.data());
                      bool isNoImage = AppUser.user?.imageUrl == null ||
                          (AppUser.user?.imageUrl ?? "").isEmpty;
                      return Card(
                        color: AppConfig.colors.cardBackGround,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          height: Get.height * 0.335,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: Get.height * 0.015),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProfileAvatar(
                                      isNoImage
                                          ? AppUtils.userAvatar
                                          : docInfo.imageUrl!,
                                      borderWidth: 1,
                                      radius: Get.width * 0.1,
                                      borderColor: AppConfig.colors.themeColor,
                                    ),
                                    SizedBox(width: Get.width * .03),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${docInfo.name}',
                                          style: GoogleFonts.roboto(
                                            fontSize: 20.0,
                                            color: const Color(0xFF19769F),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: Get.height * 0.01),
                                        Text(
                                          "need to get this",
                                          style: GoogleFonts.roboto(
                                            fontSize: 14.0,
                                            color: const Color(0xFF51565F),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: Get.height * 0.008),
                                        Container(
                                            width: Get.width * 0.38,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Get.width * 0.02,
                                                vertical: Get.height * 0.01),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${DateFormat('EEE, dd MMM ').format(appointmentData.appointmentDate!.toDate())}",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 16.0,
                                                    color:
                                                        const Color(0xFF1C1C1C),
                                                  ),
                                                ),
                                                Text(
                                                  "${DateFormat('hh:mm').format(appointmentData.appointmentDate!.toDate())}",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 16.0,
                                                    color:
                                                        const Color(0xFF2AC052),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            )),
                                        SizedBox(height: Get.height * 0.02),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: appointmentData
                                                          .appointmentType ==
                                                      0
                                                  ? 13
                                                  : 20,
                                              child: Image.asset(appointmentData
                                                          .appointmentType ==
                                                      0
                                                  ? AppConfig
                                                      .images.videoConsultIcon
                                                  : AppConfig.images
                                                      .physicalConsultIcon),
                                            ),
                                            SizedBox(width: Get.width * 0.02),
                                            Text(
                                              appointmentData.appointmentType ==
                                                      0
                                                  ? "Physical Consultation"
                                                  : 'Online Video Consultation',
                                              style: TextStyle(
                                                fontFamily: 'Corbel',
                                                fontSize: 16.0,
                                                color: const Color(0xFF1C1C1C),
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: Get.height * 0.05),
                                        if (appointmentData.appointmentType ==
                                            0)
                                          GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              width: Get.width * 0.45,
                                              height: Get.height * 0.05,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                                color:
                                                    AppConfig.colors.themeColor,
                                                border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xFF707070),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      width: Get.width * 0.055,
                                                      height: Get.width * 0.055,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    16.0)),
                                                        color: Colors.white,
                                                      ),
                                                      child: Icon(
                                                        Icons.location_pin,
                                                        color: Colors.black,
                                                        size: Get.width * 0.04,
                                                      )),
                                                  SizedBox(width: 15),
                                                  Text(
                                                    'Get Location',
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 14.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (appointmentData.appointmentType !=
                                            0)
                                          Container(
                                            width: Get.width * 0.45,
                                            height: Get.height * 0.05,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              color:
                                                  AppConfig.colors.themeColor,
                                              border: Border.all(
                                                width: 1.0,
                                                color: const Color(0xFF707070),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: Get.width * 0.055,
                                                  height: Get.width * 0.055,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                16.0)),
                                                    color: Colors.white,
                                                  ),
                                                  child: Image.asset(
                                                    appointmentData.appointmentType !=
                                                            0
                                                        ? AppConfig
                                                            .images.videoCam
                                                        : AppConfig.images
                                                            .physicalConsultIcon,
                                                    scale: 2.5,
                                                    color: AppConfig
                                                        .colors.themeColor,
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  'Join on ${DateFormat('EEE, dd MMM ').format(now)}',
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 14.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: Get.height * 0.02),
                                  ],
                                )
                              ]),
                        ),
                      );
                    }
                  });

            default:
              return Container();
          }
        });
  }
}
