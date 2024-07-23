import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/modal/doctor_info.dart';
import 'package:docsheli/modal/specialityModal.dart';
import 'package:docsheli/modal/user_data.dart';
import 'package:docsheli/providers/auth.dart';
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
        "${doctor.qualification ?? ""}".replaceAll(" ", "").toLowerCase();
    if (!toSearch.contains(searchText)) {
      return SizedBox();
    }

    return FutureBuilder(
        future: doctor.userRef?.get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmers.general();
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text('No doctor list found');
          }

          UserData user = UserData.fromJson(snapshot.data!.data()!);
          SpecialityModal sp = Provider.of<AuthProvider>(context, listen: false)
              .specialities
              .firstWhere((sp) {
                print(sp.id);
                print(doctor.specialityId);
            return sp.id == doctor.specialityId!;
          });
          return buildDoctorCard(user, doctor, sp);
        });
  }

  Widget buildDoctorCard(UserData user, DoctorInfo doctor, SpecialityModal sp) {
    bool noImage = user.imageUrl == null || user.imageUrl!.isEmpty;

    return GestureDetector(
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
          padding: EdgeInsets.all(Get.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircularProfileAvatar(
                    noImage ? AppUtils.userAvatar : user.imageUrl!,
                    borderWidth: 1,
                    radius: Get.width * 0.12,
                    borderColor: AppConfig.colors.themeColor,
                  ),
                  SizedBox(width: Get.width * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name ?? "-",
                          style: GoogleFonts.roboto(
                            fontSize: 20.0,
                            color: const Color(0xFF19769F),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.01),
                        Text(
                          sp.speciality ?? "",
                          style: GoogleFonts.roboto(
                            fontSize: 14.0,
                            color: const Color(0xFF51565F),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.008),
                        Text(
                          doctor.qualification ?? "",
                          style: TextStyle(
                            fontFamily: 'Gotham Rounded',
                            fontSize: 14.0,
                            color: const Color(0xFF51565F),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.01),
              isDoctor
                  ? buildDoctorActionButton(
                      'View Full Profile',
                      () => Get.to(
                          DoctorDetails(user: user, doctor: doctor, sp: sp)),
                    )
                  : SizedBox(height: Get.height * 0.01),
              buildExperienceAndSatisfaction(doctor.experience ?? 0),
              Divider(thickness: 2),
              isDoctor
                  ? buildDoctorActionButton(
                      'Consult Now',
                      () => Get.to(
                          DoctorDetails(user: user, doctor: doctor, sp: sp)),
                    )
                  : buildConsultationOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildExperienceAndSatisfaction(int experience) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "$experience",
                style: GoogleFonts.roboto(
                  fontSize: 12.0,
                  color: const Color(0xFF19769F),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Experience',
                style: GoogleFonts.roboto(
                  fontSize: 14.0,
                  color: const Color(0xFF1C1C1C),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '99%', // Placeholder for satisfaction
                style: GoogleFonts.roboto(
                  fontSize: 12.0,
                  color: const Color(0xFF19769F),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Satisfaction',
                style: GoogleFonts.roboto(
                  fontSize: 14.0,
                  color: const Color(0xFF1C1C1C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDoctorActionButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: Get.width * 0.35,
        height: Get.height * 0.05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: AppConfig.colors.themeColor,
          border: Border.all(
            width: 1.0,
            color: const Color(0xFF707070),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget buildConsultationOptions() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
            child: Container(
              height: Get.height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.white,
                border: Border.all(
                  width: 1.0,
                  color: const Color(0xFF707070),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppConfig.images.videoCam,
                    width: Get.width * 0.045,
                    height: Get.width * 0.045,
                    scale: 3.2,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Video Consultation',
                    style: GoogleFonts.roboto(
                      fontSize: 10.0,
                      color: const Color(0xFF1C1C1C),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
            child: GestureDetector(
              onTap: () {
                // Handle booking appointment
              },
              child: Container(
                height: Get.height * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: AppConfig.colors.themeColor,
                  border: Border.all(
                    width: 1.0,
                    color: const Color(0xFF707070),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Book Appointment',
                    style: GoogleFonts.roboto(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
