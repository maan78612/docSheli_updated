import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/modal/doctor_info.dart';
import 'package:docsheli/modal/specialityModal.dart';
import 'package:docsheli/modal/user_data.dart';
import 'package:docsheli/providers/doctor.dart';
import 'package:docsheli/ui/shared/globals/global_classes.dart';
import 'package:docsheli/ui/shared/globals/global_variables.dart';
import 'package:docsheli/ui/shared/shimmers/shimmers.dart';
import 'package:docsheli/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'doctor_details.dart';

class DoctorsList extends StatefulWidget {
  @override
  _DoctorsListState createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {
  TextEditingController searchCtrl = TextEditingController();
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorProvider>(builder: (context, p, _) {
      return Scaffold(
        backgroundColor: AppConfig.colors.backGround,
        body: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: Get.height * .04,
                ),
                Container(
                    margin: EdgeInsets.only(top: Get.height * 0.01),
                    padding: EdgeInsets.only(bottom: 20),
                    width: Get.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.width * 0.7,
                          decoration: BoxDecoration(
                              color: AppConfig.colors.cardBackGround,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(.20),
                                    spreadRadius: 2,
                                    blurRadius: 1)
                              ]),
                          margin: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.05),
                          padding: EdgeInsets.only(left: 10),
                          child: TextField(
                            textAlign: TextAlign.start,
                            controller: searchCtrl,
                            onChanged: (val) {
                              setState(() {
                                searchText = val
                                    .toString()
                                    .replaceAll(" ", "")
                                    .toLowerCase();
                              });
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: "Search for doctors",
                                hintStyle:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                contentPadding: EdgeInsets.all(0),
                                fillColor: AppConfig.colors.cardBackGround,
                                isDense: true,
                                suffixIcon: Image.asset(
                                  AppConfig.images.search,
                                  scale: 3.5,
                                )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              BottomSheetSort(),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Container(
                            // width: Get.width * 0.1,
                            // height: Get.height * .03,
                            child: Image.asset(AppConfig.images.sort,
                                scale: 4.5, fit: BoxFit.contain),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: Get.height * .02,
                ),
                Expanded(
                  child: Container(
                      // height: Get.height * 0.72,
                      width: Get.width * 0.9,
                      child: doctorList(p)),
                ),
              ]),
        ),
      );
    });
  }

  Widget doctorList(DoctorProvider p) {
    List<DoctorInfo> allDoctor;
    if (p.selectedCategoryID == null) {
      allDoctor = p.allDoctors;
    } else {
      allDoctor = p.allDoctors
          .where((doc) => doc.specialityId == p.selectedCategoryID)
          .toList();
    }
    return ListView(
      children: List.generate(allDoctor.length, (index) {
        DoctorInfo doctor = allDoctor[index];
        return doctorCard(index, doctor, p);
      }),
    );
  }

  Widget doctorCard(int index, DoctorInfo doctor, DoctorProvider p) {
    String toSearch =
        "${doctor.qualification ?? " "}".replaceAll(" ", "").toLowerCase();
    if (toSearch.contains(searchText)) {
      return FutureBuilder(
          future: doctor.userRef?.get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              print("no data");
              return Shimmers.general();
            } else {
              print(" data");
              UserData user = UserData.fromJson(snapshot.data?.data());
              return FutureBuilder<SpecialityModal?>(
                  future: p.getSpecialityById(doctor.specialityId!),
                  builder: (context, AsyncSnapshot<SpecialityModal?> specShot) {
                    if (!specShot.hasData) {
                      return Shimmers.general();
                    } else if (specShot.data == null) {
                      return Container();
                    } else {
                      SpecialityModal sp = specShot.data!;
                      bool noImage =
                          user.imageUrl == null || (user.imageUrl??"").isEmpty;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(DoctorDetails(
                                user: user,
                                doctor: doctor,
                                sp: sp,
                              ));
                            },
                            child: Card(
                              color: AppConfig.colors.cardBackGround,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Container(
                                height: Get.height * 0.335,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: Get.height * 0.015),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProfileAvatar(
                                          noImage
                                              ? AppUtils.userAvatar
                                              : user.imageUrl!,
                                          borderWidth: 1,
                                          radius: Get.width * 0.12,
                                          borderColor:
                                              AppConfig.colors.themeColor,
                                        ),
                                        SizedBox(width: Get.width * .03),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${user.name ?? "-"}',
                                              style: GoogleFonts.roboto(
                                                fontSize: 20.0,
                                                color: const Color(0xFF19769F),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: Get.height * 0.01),
                                            Text(
                                              "${sp.speciality ?? ""}",
                                              style: GoogleFonts.roboto(
                                                fontSize: 14.0,
                                                color: const Color(0xFF51565F),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(
                                                height: Get.height * 0.008),
                                            Text(
                                              '${doctor.qualification ?? ""}',
                                              style: TextStyle(
                                                fontFamily: 'Gotham Rounded',
                                                fontSize: 14.0,
                                                color: const Color(0xFF51565F),
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            // SizedBox(
                                            //     height: Get.height * 0.005),
                                            // Row(
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.start,
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.start,
                                            //   children: [
                                            //     Icon(
                                            //       Icons.location_on_outlined,
                                            //       color: AppConfig
                                            //           .colors.themeColor,
                                            //       size: 15,
                                            //     ),
                                            //     ConstrainedBox(
                                            //       constraints: BoxConstraints(
                                            //           maxWidth:
                                            //               Get.width * 0.5),
                                            //       child: FutureBuilder(
                                            //           future: ls.getAddressByLatLng(
                                            //               doctor.doctorLocation
                                            //                       ?.lat ??
                                            //                   "",
                                            //               doctor.doctorLocation
                                            //                       ?.lng ??
                                            //                   0.0),
                                            //           builder:
                                            //               (context, lshot) {
                                            //             if (!lshot.hasData) {
                                            //               return Text("");
                                            //             } else {
                                            //               return Text(
                                            //                 '${lshot.data}',
                                            //                 maxLines: 2,
                                            //                 overflow:
                                            //                     TextOverflow
                                            //                         .ellipsis,
                                            //                 style: TextStyle(
                                            //                   fontFamily:
                                            //                       'Gotham Rounded',
                                            //                   fontSize: 12.0,
                                            //                   color: const Color(
                                            //                       0xFF51565F),
                                            //                   fontWeight:
                                            //                       FontWeight
                                            //                           .w300,
                                            //                 ),
                                            //               );
                                            //             }
                                            //           }),
                                            //     ),
                                            //   ],
                                            // )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: Get.height * 0.01),
                                    if (isDoctor)
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(DoctorDetails(
                                            user: user,
                                            doctor: doctor,
                                            sp: sp,
                                          ));
                                        },
                                        child: Center(
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: Get.width * 0.25,
                                            height: Get.height * .03,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.44),
                                                  offset: Offset(0, 3.0),
                                                  blurRadius: 6.0,
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              'View Full Profile',
                                              style: GoogleFonts.roboto(
                                                fontSize: 11.0,
                                                color: const Color(0xFF1C1C1C),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (!isDoctor)
                                      SizedBox(height: Get.height * 0.01),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Get.width * 0.05),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${doctor.experience}',
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 12.0,
                                                    color:
                                                        const Color(0xFF19769F),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  'Experience',
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 14.0,
                                                    color:
                                                        const Color(0xFF1C1C1C),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '99%',
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 12.0,
                                                    color:
                                                        const Color(0xFF19769F),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  'Satisfaction',
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 14.0,
                                                    color:
                                                        const Color(0xFF1C1C1C),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.01),
                                              ],
                                            ),
                                          ]),
                                    ),
                                    Divider(
                                      thickness: 2,
                                    ),
                                    SizedBox(height: Get.height * 0.01),
                                    !isDoctor
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          Get.width * 0.05),
                                                  child: Container(
                                                    height: Get.height * 0.05,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        width: 1.0,
                                                        color: const Color(
                                                            0xFF707070),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width:
                                                              Get.width * 0.045,
                                                          height:
                                                              Get.width * 0.045,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        16.0)),
                                                            color: AppConfig
                                                                .colors
                                                                .themeColor,
                                                          ),
                                                          child: Image.asset(
                                                            AppConfig.images
                                                                .videoCam,
                                                            scale: 3.2,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          'Video Consultation',
                                                          style: GoogleFonts
                                                              .roboto(
                                                            fontSize: 10.0,
                                                            color: const Color(
                                                                0xFF1C1C1C),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          Get.width * 0.05),
                                                  child: Container(
                                                    height: Get.height * 0.05,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                      color: AppConfig
                                                          .colors.themeColor,
                                                      border: Border.all(
                                                        width: 1.0,
                                                        color: const Color(
                                                            0xFF707070),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Book Appointment',
                                                          style: GoogleFonts
                                                              .roboto(
                                                            fontSize: 12.0,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(DoctorDetails(
                                                  user: user,
                                                  doctor: doctor,
                                                  sp: sp,
                                                ));
                                              },
                                              child: Container(
                                                width: Get.width * 0.35,
                                                height: Get.height * 0.05,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                  color: AppConfig
                                                      .colors.themeColor,
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
                                                    Text(
                                                      'Consult Now',
                                                      style: GoogleFonts.roboto(
                                                        fontSize: 14.0,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.02,
                          )
                        ],
                      );
                    }
                  });
            }
          });
    } else {
      return SizedBox();
    }
  }
}
