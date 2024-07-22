import 'package:docsheli/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title, body, buttonName;

  const ConfirmationDialog({required this.title, required this.body, required this.buttonName});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Container(
              height: 4,
              width: Get.width * 0.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Colors.grey.withOpacity(0.5)),
            ),
          ),
          SizedBox(
            height: Get.height * 0.024,
          ),
          Container(
            width: Get.height * 0.1,
            height: Get.height * 0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepOrangeAccent.withOpacity(0.3),
            ),
            child: Container(
              child: Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 48,
                  color: Colors.deepOrangeAccent.withOpacity(0.9),
                ),
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.024,
          ),
          Text(
            title,
            style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Text(
            body,
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: 'Avenir',
              color: const Color(0xFF282425),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
            child: Container(
              alignment: FractionalOffset.bottomCenter,
              padding: EdgeInsets.only(bottom: 38),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: MaterialButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: Colors.deepOrangeAccent.withOpacity(0.75),
                      onPressed: () {
                        Get.back(result: false);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  Expanded(
                    child: MaterialButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: AppConfig.colors.themeColor.withOpacity(0.65),
                      onPressed: () {
                        Get.back(result: true);
                      },
                      child: Text(
                        buttonName ?? "Yes",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
