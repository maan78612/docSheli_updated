import 'package:docsheli/constants/app_constants.dart';

import 'package:docsheli/ui/patient/semi_dashbooard.dart';
import 'package:docsheli/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PaymentConfirm extends StatelessWidget {
  final String doctorName;
  final DateTime date;
  final bool isVideo;

  PaymentConfirm(
      {required this.doctorName, required this.date, required this.isVideo});

  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppConfig.colors.backGround,
        appBar: AppBar(
          backgroundColor: AppConfig.colors.themeColor,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_outlined),
          ),
          title: Center(
            child: Text(
              'Payment Confirmed',
              style: GoogleFonts.roboto(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: Get.width * 0.05, vertical: Get.height * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dr. ${doctorName}',
                style: GoogleFonts.roboto(
                  fontSize: 16.0,
                  color: const Color(0xFF1C1C1C),
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Container(
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
                        "${DateFormat('EEE, dd MMM ').format(date)}",
                        style: GoogleFonts.lato(
                          fontSize: 25.0,
                          color: const Color(0xFF1C1C1C),
                        ),
                      ),
                      Text(
                        "${DateFormat('hh:mm').format(date)}",
                        style: GoogleFonts.lato(
                          fontSize: 25.0,
                          color: const Color(0xFF2AC052),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(AppConfig.images.myAppointments, scale: 3),
                  SizedBox(width: Get.width * 0.02),
                  Text(
                    isVideo
                        ? 'Online Video Consultation'
                        : "Physical Consultation",
                    style: TextStyle(
                      fontFamily: 'Corbel',
                      fontSize: 22.0,
                      color: const Color(0xFF1C1C1C),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppConfig.images.confirm, scale: 3),
                  SizedBox(width: Get.width * 0.02),
                  Text(
                    'Appointment Confirmed!',
                    style: GoogleFonts.lato(
                      fontSize: 16.0,
                      color: const Color(0xFF1C1C1C),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.05),
              Center(
                child: Container(
                  height: Get.height * 0.3,
                  child: Image.asset(
                    AppConfig.images.paymentConfirm,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      AppRoutes.popUntil(context, SemiDashBoard(0), 3);
                    },
                    child: Container(
                      width: Get.width * 0.9,
                      height: Get.height * 0.065,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color(0xFF2A2AC0),
                      ),
                      child: Center(
                        child: Text(
                          'Done',
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
                ],
              ),
              SizedBox(height: Get.height * 0.05),
              Center(
                child: FutureBuilder<String>(future: Future.microtask(() {
                  String days = date.difference(now).inDays.toString();
                  int total = date.difference(now).inHours;

                  String hours = (total % 24).toString();
                  return "$days and $hours hours";
                }), builder: (context, snapshot) {
                  return Text.rich(
                    TextSpan(
                      style: GoogleFonts.lato(
                        fontSize: 14.0,
                        color: const Color(0xFF1C1C1C),
                      ),
                      children: [
                        TextSpan(
                          text: snapshot.data,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: ' before the appointment',
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  );
                }),
              ),
            ],
          ),
        )));
  }
}
