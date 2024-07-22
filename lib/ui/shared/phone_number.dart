import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class PhoneNumberScreen extends StatefulWidget {
  @override
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  FocusNode numberFocus = new FocusNode();

  PhoneNumber initialPhoneValue = PhoneNumber(isoCode: 'IL', dialCode: "+972");

  TextEditingController phoneNumberCon = TextEditingController();
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, model, _) {
      return Scaffold(
        backgroundColor: AppConfig.colors.backGround,
        body: SingleChildScrollView(
            child: Container(
          color: AppConfig.colors.backGround,
          width: Get.width,
          height: Get.height,
          margin: EdgeInsets.symmetric(horizontal: Get.width * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.1),
              Image.asset(AppConfig.images.logo, scale: 3),
              SizedBox(height: Get.height * 0.03),
              Image.asset(AppConfig.images.otpImg, scale: 1),
              SizedBox(height: Get.height * 0.02),
              Text(
                'Mobile Number',
                style: GoogleFonts.lato(
                  fontSize: 26.0,
                  color: const Color(0xFF181461),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Get.height * 0.01),
              Text(
                'The code will be sent to  mobile number',
                style: GoogleFonts.lato(
                  fontSize: 16.0,
                  color: const Color(0xFF1C1C1C),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Get.height * 0.05),
              customNumberPicker(model),
              SizedBox(height: Get.height * 0.02),
              model.isLoading
                  ? CircularProgressIndicator()
                  : Container(
                      width: Get.width,
                      height: Get.height * 0.065,
                      child: ElevatedButton(
                        onPressed: () =>
                            model.verifyNumber(phoneNumber: phoneNumber),
                        child: Text(
                          'Continue',
                          style: GoogleFonts.lato(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppConfig.colors.themeColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(
                                        color: AppConfig.colors.themeColor)))),
                      ),
                    )
            ],
          ),
        )),
      );
    });
  }

  Widget customNumberPicker(AuthProvider model) {
    return Stack(
      children: [
        Container(
          height: 48,
          width: 105,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: numberFocus.hasFocus
                      ? AppConfig.colors.themeColor
                      : Colors.white,
                  width: 1)),
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InternationalPhoneNumberInput(
                focusNode: numberFocus,
                key: Key("phone_number_cap"),
                textStyle: TextStyle(
                  fontSize: Get.height * 0.018,
                  fontFamily: "quick",
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),

                inputDecoration: InputDecoration(
                  focusColor: numberFocus.hasFocus
                      ? AppConfig.colors.themeColor
                      : Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide:
                        BorderSide(width: 1, color: AppConfig.colors.iconGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(
                        width: 1, color: AppConfig.colors.themeColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(width: 1, color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(width: 1, color: Colors.red),
                  ),
                  isDense: true,
                  labelText: "00-000-000",
                  labelStyle: TextStyle(
                    fontSize: Get.height * 0.018,
                    fontFamily: "quick",
                    fontWeight: FontWeight.bold,
                    color: numberFocus.hasFocus
                        ? AppConfig.colors.themeColor
                        : AppConfig.colors.iconGrey,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onInputChanged: (PhoneNumber phoneNumber) {
                  if (phoneNumber.phoneNumber != null)
                    this.phoneNumber = phoneNumber.phoneNumber!;
                },

                //  selectorType: PhoneInputSelectorType.BOTTOM_SH//
                selectorConfig:
                    SelectorConfig(selectorType: PhoneInputSelectorType.DIALOG),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.onUserInteraction,

                selectorTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: "quick",
                    fontSize: Get.height * 0.018),
                initialValue: initialPhoneValue,
                textFieldController: phoneNumberCon,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
