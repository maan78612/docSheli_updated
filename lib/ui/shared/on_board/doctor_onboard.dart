import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/providers/doctor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../phone_number.dart';

class DoctorOnBoarding extends StatefulWidget {
  @override
  _DoctorOnBoardingState createState() => _DoctorOnBoardingState();
}

class _DoctorOnBoardingState extends State<DoctorOnBoarding> {
  PageController _onBoardingPageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorProvider>(builder: (context, model, _) {
      return Scaffold(
        backgroundColor: AppConfig.colors.backGround,
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: Get.width * .03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Get.offAll(() => PhoneNumberScreen());
                },
                child: Container(
                    color: AppConfig.colors.backGround,
                    height: 30,
                    width: 50,
                    child: Center(
                        child: Text(
                      "Skip",
                      style: GoogleFonts.poppins().copyWith(
                        color: AppConfig.colors.themeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.width * .033,
                      ),
                    ))),
              ),
              Container(
                  height: 40,
                  width: 50,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _onBoardingPageController,
                      count: 3,
                      effect: ExpandingDotsEffect(
                        dotWidth: 8,
                        dotHeight: 8,
                        spacing: 3,
                        dotColor: AppConfig.colors.themeColor.withOpacity(.1),
                        activeDotColor: AppConfig.colors.themeColor,
                      ),
                    ),
                  )),
              TextButton(
                onPressed: () {
                  model.onBoardingJumpToPageFunc(_onBoardingPageController);
                },
                child: Container(
                    color: AppConfig.colors.backGround,
                    height: 40,
                    width: 50,
                    child: Center(
                        child: Text(
                      "Next",
                      style: GoogleFonts.poppins().copyWith(
                        color: AppConfig.colors.themeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.width * .033,
                      ),
                    ))),
              ),
            ],
          ),
        ),
        body: Container(
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _onBoardingPageController,
            children: [
              AppConfig.widgets.onBoardingCard(
                  "Consult with Patients", AppConfig.images.doctorOnBoard1),
              AppConfig.widgets.onBoardingCard("View Pateints Medical Records",
                  AppConfig.images.patientOnBoard2),
              AppConfig.widgets.onBoardingCard("Online & Physical Appointment",
                  AppConfig.images.patientOnBoard3),
            ],
          ),
        ),
      );
    });
  }
}
