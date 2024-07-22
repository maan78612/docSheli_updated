import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/modal/appointment.dart';
import 'package:docsheli/modal/user_data.dart';
import 'package:docsheli/providers/auth.dart';
import 'package:docsheli/providers/patient.dart';
import 'package:docsheli/ui/doctor/patient_medical_record.dart';
import 'package:docsheli/ui/shared/shimmers/shimmers.dart';
import 'package:docsheli/ui/sign_up/patient_signup.dart';
import 'package:docsheli/utils/app_utils.dart';
import 'package:docsheli/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Patient extends StatefulWidget {
  final bool isAppointment;

  Patient({this.isAppointment = false});

  @override
  _PatientState createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProvider>(builder: (context, patientProvider, _) {
      return Scaffold(
        body: Container(
          child: ListView(
            children: List.generate(
                patientProvider.getAppointmentList
                    .where((element) =>
                        element.doctorId ==
                        Provider.of<AuthProvider>(context, listen: false)
                            .appUser
                            ?.phone)
                    .toList()
                    .length, (index) {
              AppointmentModal appointmentData = patientProvider
                  .getAppointmentList
                  .where((element) =>
                      element.doctorId ==
                      Provider.of<AuthProvider>(context, listen: false)
                          .appUser
                          ?.phone)
                  .toList()[index];
              return _mainPatientsCard(appointmentData, patientProvider);
            }),
          ),
        ),
      );
    });
  }

  Widget _mainPatientsCard(
      AppointmentModal appointmentData, PatientProvider patientProvider) {
    return FutureBuilder(
        future:
            patientProvider.getSinglePatientInfo(appointmentData.patientID!),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Shimmers.general();

            case ConnectionState.waiting:
              return Shimmers.general();

            case ConnectionState.active:
              return Shimmers.general();

            case ConnectionState.done:
              UserData patientInfo = UserData.fromJson(snapshot.data.data());

              return Container(
                margin: EdgeInsets.symmetric(
                    horizontal: Get.width * .04, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black)),
                width: Get.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProfileAvatar(
                            "",
                            child: Image.network(
                              (patientInfo.imageUrl == null ||
                                      patientInfo.imageUrl!.isEmpty)
                                  ? AppUtils.userAvatar
                                  : patientInfo.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                            borderWidth: 1,
                            radius: Get.width * 0.1,
                            borderColor: AppConfig.colors.themeColor,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${patientInfo.name}',
                              style: AppConfig.textStyle.poppins().copyWith(
                                  color: Color(0xff19769F),
                                  fontWeight: FontWeight.bold,
                                  fontSize: Get.width * .045),
                            ),
                            Container(
                                width: Get.width * 0.42,
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.02,
                                    vertical: Get.height * 0.01),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${DateFormat('EEE, dd MMM ').format(appointmentData.appointmentDate!.toDate())}",
                                      style: GoogleFonts.lato(
                                        fontSize: 16.0,
                                        color: const Color(0xFF1C1C1C),
                                      ),
                                    ),
                                    Text(
                                      "${DateFormat('hh:mm').format(appointmentData.appointmentDate!.toDate())}",
                                      style: GoogleFonts.lato(
                                        fontSize: 16.0,
                                        color: const Color(0xFF2AC052),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height:
                                          appointmentData.appointmentType == 0
                                              ? 13
                                              : 20,
                                      child: Image.asset(appointmentData
                                                  .appointmentType ==
                                              0
                                          ? AppConfig.images.physicalConsultIcon
                                          : AppConfig.images.videoConsultIcon),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      appointmentData.appointmentType == 0
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
                                )),
                          ],
                        ),
                      ],
                    ),
                    widget.isAppointment
                        ? SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                elevation: 3,
                                minWidth: Get.width * .38,
                                height: 35,
                                color: Colors.white,
                                child: Center(
                                  child: Text("View Full Profile",
                                      style: AppConfig.textStyle
                                          .poppins()
                                          .copyWith(
                                            fontSize: Get.width * .03,
                                            color: Colors.black,
                                          )),
                                ),
                                onPressed: () {
                                  Get.to(() => PatientSignUp(
                                        isProfile: true,
                                        appBarTitle: "Patient Profile",
                                        subTitle: "Profile",
                                        profileData: patientInfo,
                                      ));
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                elevation: 3,
                                minWidth: Get.width * .38,
                                height: 35,
                                color: Colors.white,
                                child: Center(
                                  child: Text("View Medical Records",
                                      style: AppConfig.textStyle
                                          .poppins()
                                          .copyWith(
                                            fontSize: Get.width * .03,
                                            color: Colors.black,
                                          )),
                                ),
                                onPressed: () {
                                  setState(() async {
                                    var patientProvider =
                                        Provider.of<PatientProvider>(
                                            Get.context!,
                                            listen: false);
                                    patientProvider.onDisposeMedical();
                                    await patientProvider.getMedicalRecord(
                                        appointmentData.patientID!);
                                    Get.to(() => PatientMedicalRecord());
                                  });
                                },
                              ),
                            ],
                          ),
                    widget.isAppointment
                        ? Center(
                            child: Container(
                              margin:
                                  EdgeInsets.only(bottom: Get.height * 0.02),
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
                                    appointmentData.appointmentType == 0
                                        ? 'Consult on "${DateFormat('EEE, dd MMM ').format(appointmentData.appointmentDate!.toDate())}'
                                        : 'Join on "${DateFormat('EEE, dd MMM ').format(appointmentData.appointmentDate!.toDate())}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 10.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * .15, vertical: 10),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              elevation: 3,
                              minWidth: Get.width * .6,
                              height: 40,
                              color: AppConfig.colors.themeColor,
                              child: Center(
                                child: Text(
                                    "Appointment on ${"${DateFormat('EEE, dd MMM ').format(appointmentData.appointmentDate!.toDate())}"}",
                                    style:
                                        AppConfig.textStyle.poppins().copyWith(
                                              fontSize: Get.width * .03,
                                              color: Colors.white,
                                            )),
                              ),
                              onPressed: () {
                                widget.isAppointment
                                    ? SizedBox()
                                    : AppRoutes.push(
                                        context,
                                        Patient(
                                          isAppointment: true,
                                        ));
                              },
                            ),
                          ),
                  ],
                ),
              );

            default:
              return Container();
          }
        });
  }
}
