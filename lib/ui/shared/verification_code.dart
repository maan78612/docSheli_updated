import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/providers/auth.dart';
import 'package:docsheli/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerificationCode extends StatelessWidget {
  final String verificationId;

  VerificationCode(this.verificationId);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
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
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: customPinNumber(context, authProvider),
              ),
              SizedBox(height: Get.height * 0.02),
              authProvider.isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      width: Get.width,
                      height: Get.height * 0.065,
                      child: ElevatedButton(
                        onPressed: () {
                          authProvider.verifyOTP(
                              verificationId: verificationId);
                        },
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

  Widget customPinNumber(BuildContext context, AuthProvider authProvider) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 1)),
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: Get.width * .03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: false,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  inactiveColor: Colors.grey,
                  activeColor: Colors.grey,
                  selectedColor: Colors.black,
                  activeFillColor: AppConfig.colors.themeColor,
                  disabledColor: Colors.white,
                  fieldHeight: Get.width * .10,
                  fieldWidth: Get.width * .08,
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.white,
                validator: FieldValidator.validatePin,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  authProvider.setPinNumber(value);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Image.asset(AppConfig.images.cancel,
                  scale: 3, color: Color(0xff1C1C1C)),
            )
          ],
        ));
  }
}
