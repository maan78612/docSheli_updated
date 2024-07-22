import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/modal/doctor_info.dart';
import 'package:docsheli/modal/specialityModal.dart';
import 'package:docsheli/modal/user_data.dart';
import 'package:docsheli/providers/auth.dart';
import 'package:docsheli/providers/patient.dart';
import 'package:docsheli/ui/patient/review.dart';
import 'package:docsheli/ui/shared/globals/global_variables.dart';
import 'package:docsheli/utils/app_user.dart';
import 'package:docsheli/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'booking_screen.dart';

class DoctorDetails extends StatelessWidget {
  final UserData user;
  final DoctorInfo doctor;
  final SpecialityModal sp;

  DoctorDetails({required this.doctor, required this.sp, required this.user});

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProvider>(builder: (context, model, _) {
      return Scaffold(
          backgroundColor: AppConfig.colors.backGround,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppConfig.colors.themeColor,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios_outlined),
            ),
            title: Text(
              'Doctor Profile',
              style: GoogleFonts.roboto(
                fontSize: 22.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          bottomNavigationBar: (!isDoctor)
              ? Container(
                  margin: EdgeInsets.only(bottom: Get.height * 0.02),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.to(BookAppointment(
                            isVideo: true,
                            doc: doctor,
                            doctorInfo: user,
                            sp: sp,
                          ));
                        },
                        child: Container(
                          width: Get.width * 0.39,
                          height: Get.height * 0.045,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: Get.width * 0.045,
                                height: Get.width * 0.049,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                  color: AppConfig.colors.themeColor,
                                ),
                                child: Image.asset(
                                  AppConfig.images.videoCam,
                                  scale: 3.2,
                                ),
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
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.to(BookAppointment(
                            isVideo: false,
                            doc: doctor,
                            doctorInfo: user,
                            sp: sp,
                          ));
                        },
                        child: Container(
                          width: Get.width * 0.39,
                          height: Get.height * 0.045,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: AppConfig.colors.themeColor,
                            border: Border.all(
                              width: 1.0,
                              color: const Color(0xFF707070),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Book Appointment',
                                style: GoogleFonts.roboto(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                )
              : Container(height: 0, width: 0),
          body: doctorCard(model, context));
    });
  }

  Widget doctorCard(PatientProvider model, BuildContext context) {
    bool noImage = user.imageUrl == null || (user.imageUrl ?? "").isEmpty;
    return Container(
      margin: EdgeInsets.only(top: Get.height * 0.02),
      // color: Colors.white,
      child: Card(
        color: AppConfig.colors.cardBackGround,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        child: Container(
          // height: Get.height * 0.76,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.015),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProfileAvatar(
                    noImage ? AppUtils.userAvatar : user.imageUrl!,
                    borderWidth: 1,
                    radius: Get.width * 0.12,
                    borderColor: AppConfig.colors.themeColor,
                  ),
                  SizedBox(width: Get.width * .03),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(height: Get.height * 0.008),
                      Text(
                        '${doctor.qualification ?? ""}',
                        style: TextStyle(
                          fontFamily: 'Gotham Rounded',
                          fontSize: 14.0,
                          color: const Color(0xFF51565F),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: Get.width * .06),
                  GestureDetector(
                    onTap: () async {
                      bool check = await model.checkAppointmentForBool(
                          patientId:
                              Provider.of<AuthProvider>(context, listen: false)
                                  .appUser!
                                  .phone!,
                          docID: "+923017797394");
                      check
                          ? Get.to(ReviewDoctor())
                          : Get.snackbar(
                              "Review",
                              "There is no appointment found of you with this doctor "
                                  "",
                              backgroundColor: AppConfig.colors.white,
                              colorText: AppConfig.colors.themeColor);
                    },
                    child: Text(
                      'Review here',
                      style: GoogleFonts.roboto(
                          fontSize: Get.width * 0.031,
                          color: const Color(0xFF19769F),
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.0007),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.07),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${doctor.experience ?? 0} Years',
                            style: GoogleFonts.roboto(
                              fontSize: 12.0,
                              color: const Color(0xFF19769F),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Experience',
                            style: GoogleFonts.roboto(
                              fontSize: 14.0,
                              color: const Color(0xFF1C1C1C),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '99%',
                            style: GoogleFonts.roboto(
                              fontSize: 12.0,
                              color: const Color(0xFF19769F),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Satisfaction',
                            style: GoogleFonts.roboto(
                              fontSize: 14.0,
                              color: const Color(0xFF1C1C1C),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: Get.height * 0.01),
                        ],
                      ),
                    ]),
              ),
              Divider(
                thickness: 1,
                color: AppConfig.colors.dividerClr,
                indent: Get.width * 0.07,
                endIndent: Get.width * 0.07,
              ),
              Center(
                child: Text(
                  'Book Appointment',
                  style: GoogleFonts.roboto(
                    fontSize: 20.0,
                    color: const Color(0xFF1C1C1C),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                thickness: 1,
                color: AppConfig.colors.dividerClr,
                indent: Get.width * 0.07,
                endIndent: Get.width * 0.07,
              ),
              SizedBox(height: Get.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: Get.width * 0.15),
                  Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                  SizedBox(width: Get.width * 0.01),
                  Text(
                    'Clinic',
                    style: TextStyle(
                      fontFamily: 'Corbel',
                      fontSize: 18.0,
                      color: const Color(0xFF1C1C1C),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.003),
              Padding(
                padding: EdgeInsets.only(left: Get.width * 0.15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          color: AppConfig.colors.greenClr,
                        ),
                        SizedBox(width: Get.width * 0.01),
                        Text(
                          'Available days',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            color: AppConfig.colors.greenClr,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Wrap(
                      children: List.generate(
                        doctor.availableDays?.length ?? 0,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2),
                          child: Text(
                            '${doctor.availableDays![index]}',
                            style: GoogleFonts.roboto(
                              color: const Color(0xFF1C1C1C),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.015),
              Padding(
                padding: EdgeInsets.only(left: Get.width * 0.15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          color: AppConfig.colors.greenClr,
                        ),
                        SizedBox(width: Get.width * 0.01),
                        Text(
                          'Available time slots',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            color: AppConfig.colors.greenClr,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Wrap(
                      children: List.generate(
                        doctor.availableSlots?.length ?? 0,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2),
                          child: Text(
                            '${doctor.availableSlots![index]}',
                            style: GoogleFonts.roboto(
                              color: const Color(0xFF1C1C1C),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.015),
              if (!isDoctor)
                Center(
                  child: Container(
                    width: Get.width * 0.45,
                    height: Get.height * 0.047,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: AppConfig.colors.themeColor,
                      border: Border.all(
                        width: 1.0,
                        color: const Color(0xFF707070),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Book Appointment',
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
                ),
              SizedBox(height: Get.height * 0.01),
              Divider(
                thickness: 1,
                color: AppConfig.colors.dividerClr,
                indent: Get.width * 0.07,
                endIndent: Get.width * 0.07,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: Get.width * 0.15),
                  Image.asset(AppConfig.images.computer, scale: 4),
                  SizedBox(width: Get.width * 0.015),
                  Text(
                    'Online Video Consultation',
                    style: TextStyle(
                      fontFamily: 'Corbel',
                      fontSize: 18.0,
                      color: const Color(0xFF1C1C1C),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.003),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: Get.width * 0.15),
                  Icon(
                    Icons.watch_later_outlined,
                    color: AppConfig.colors.greenClr,
                  ),
                  SizedBox(width: Get.width * 0.01),
                  Text(
                    'Available tomorrow',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      color: AppConfig.colors.greenClr,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  Text(
                    ' 4:00PM-6:00PM',
                    style: GoogleFonts.roboto(
                      color: const Color(0xFF1C1C1C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: Get.height * 0.015),
              !isDoctor
                  ? Center(
                      child: Container(
                        width: Get.width * 0.45,
                        height: Get.height * 0.047,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: AppConfig.colors.themeColor,
                          border: Border.all(
                            width: 1.0,
                            color: const Color(0xFF707070),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Get.width * 0.045,
                              height: Get.width * 0.045,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                                color: Colors.white,
                              ),
                              child: Image.asset(
                                AppConfig.images.videoCam,
                                scale: 3.2,
                                color: AppConfig.colors.themeColor,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Book Video Consultation',
                              style: GoogleFonts.roboto(
                                fontSize: 12.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        width: Get.width * 0.45,
                        height: Get.height * 0.047,
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
                            'Chat Now',
                            style: GoogleFonts.roboto(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: Get.height * 0.015),
              Divider(
                thickness: 1,
                color: AppConfig.colors.dividerClr,
                indent: Get.width * 0.07,
                endIndent: Get.width * 0.07,
              ),
              Center(
                child: // Group: Group 8230

                    Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: Get.width * 0.15),
                    SvgPicture.string(
                      // ic_star_24px
                      '<svg viewBox="38.11 630.0 15.79 15.0" ><path transform="translate(36.11, 628.0)" d="M 9.894737243652344 14.05526447296143 L 14.77368545532227 17 L 13.47894859313965 11.44999980926514 L 17.78947448730469 7.715789318084717 L 12.11315822601318 7.23421049118042 L 9.894737243652344 2 L 7.676315307617188 7.23421049118042 L 2 7.715789318084717 L 6.310526371002197 11.44999980926514 L 5.01578950881958 17 L 9.894737243652344 14.05526447296143 Z" fill="#000000" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                      width: 15.79,
                      height: 15.0,
                    ),
                    SizedBox(width: Get.width * 0.02),
                    Text(
                      'Reviews of Dr. ${user.name ?? ""}',
                      style: TextStyle(
                        fontFamily: 'Ebrima',
                        fontSize: 14.0,
                        color: const Color(0xFF1C1C1C),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                color: AppConfig.colors.dividerClr,
                indent: Get.width * 0.07,
                endIndent: Get.width * 0.07,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: Get.width * 0.17,
                          height: Get.width * 0.17,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            color: AppConfig.colors.themeColor,
                          ),
                          child: Center(
                            child: Text(
                              '97%',
                              style: TextStyle(
                                fontFamily: 'Ebrima',
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.01),
                        Text(
                          'Satisfied out of \n169 Patients',
                          style: TextStyle(
                            fontFamily: 'Ebrima',
                            fontSize: 8.0,
                            color: const Color(0xFF1C1C1C),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        progressBar("Doctor Checkup", 95 / 100),
                        progressBar("Clinic Facility", 98 / 100),
                        progressBar("Staff Behaviour", 98 / 100),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget progressBar(String title, double percentage) {
    return Container(
      width: Get.width * 0.35,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.025, vertical: Get.height * 0.005),
              child: Text(
                '$title',
                style: TextStyle(
                  fontFamily: 'Ebrima',
                  fontSize: 8.0,
                  color: const Color(0xFF1C1C1C),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            LinearPercentIndicator(
              backgroundColor: Colors.white,
              animation: true,
              lineHeight: Get.height * 0.007,
              animationDuration: 1000,
              percent: percentage,
              linearStrokeCap: LinearStrokeCap.butt,
              progressColor: AppConfig.colors.themeColor,
            )
          ],
        ),
      ),
    );
  }

  void onChatNowTapped() async {
    String message =
        "Hey Dr. ${user.name},\nThis is Dr. ${AppUser.user?.name} from Docsheli\nI Wanted to discuss a case study with you if you don't mind.";

    print(message);
  }
}
