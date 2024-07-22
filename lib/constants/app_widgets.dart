import 'package:docsheli/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppWidgets {
  // onBoarding widget
  Widget onBoardingCard(String title, img) {
    return Container(
      margin: EdgeInsets.only(top: Get.height * .07),
      child: Column(
        children: [
          Image.asset(
            AppConfig.images.logo,
            scale: 4,
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: Get.width * .4,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppConfig.textStyle.lato().copyWith(
                  color: Color(0xff181461),
                  fontSize: Get.width * .05,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Image.asset(img),
        ],
      ),
    );
  }
}
