import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/modal/rating.dart';
import 'package:docsheli/providers/auth.dart';
import 'package:docsheli/providers/patient.dart';
import 'package:docsheli/ui/shared/globals/global_classes.dart';
import 'package:docsheli/ui/sign_up/patient_signup.dart';
import 'package:docsheli/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class ReviewDoctor extends StatefulWidget {
  @override
  _ReviewDoctorState createState() => _ReviewDoctorState();
}

class _ReviewDoctorState extends State<ReviewDoctor> {
  TextEditingController feedBackCon = new TextEditingController();
  Rating setRating = Rating();

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProvider>(builder: (context, patientProvider, _) {
      return Scaffold(
        backgroundColor: AppConfig.colors.backGround,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppConfig.colors.backGround,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_outlined,
                color: AppConfig.colors.themeColor),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                print("profile image");
                Get.to(PatientSignUp(
                  appBarTitle: "Account Settings",
                  subTitle: "Profile",
                  isProfile: true,
                  profileData: Provider.of<AuthProvider>(context, listen: false)
                      .appUser!,
                ));
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  AppConfig.images.profile,
                  color: AppConfig.colors.themeColor,
                  scale: 4,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height * .03,
                    ),
                    Text(
                      'Leave your feedback',
                      style: GoogleFonts.lato(
                        fontSize: 16.0,
                        color: const Color(0xFF1C1C1C),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.04),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProfileAvatar(
                          "",
                          child: Image.asset(
                            AppConfig.images.doc1,
                            fit: BoxFit.cover,
                          ),
                          borderWidth: 1,
                          radius: Get.width * 0.12,
                          borderColor: AppConfig.colors.themeColor,
                        ),
                        SizedBox(width: Get.width * .04),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dr. Robort Wethal',
                              style: GoogleFonts.roboto(
                                fontSize: 20.0,
                                color: const Color(0xFF19769F),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.005),
                            Text(
                              "Dermatoligist",
                              style: GoogleFonts.roboto(
                                fontSize: 14.0,
                                color: const Color(0xFF51565F),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.007),
                            Text(
                              '2 Rue de Ermesinde\nFrisange - Luxembourg 3 km',
                              style: GoogleFonts.lato(
                                fontSize: 16.0,
                                color: const Color(0xFF1C1C1C).withOpacity(0.4),
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 0),
                                  child: SmoothStarRating(
                                      rating: 4,
                                      allowHalfRating: false,
                                      starCount: 5,
                                      size: 18.0,
                                      filledIconData: Icons.star,
                                      halfFilledIconData: Icons.star_half,
                                      defaultIconData: Icons.star_border,
                                      color: Color(0xFFE6C010),
                                      borderColor: Color(0xFFE6C010),
                                      spacing: 1.0),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "(25)",
                                  style: TextStyle(
                                      color: Color(0xff1C1C1C),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'Gilroy'),
                                ),
                              ],
                            ),
                            SizedBox(height: Get.height * 0.02),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      thickness: 1,
                      // color: AppConfig.colors.dividerClr,
                      indent: Get.width * 0.07,
                      endIndent: Get.width * 0.07,
                    ),
                    SizedBox(height: Get.height * 0.03),
                    reviews(patientProvider),
                    SizedBox(height: Get.height * 0.03),
                    Center(
                      child: Container(
                          width: Get.width * 0.8,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(6.0),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.16),
                                offset: Offset(0, 3.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            textAlign: TextAlign.start,
                            controller: feedBackCon,
                            // focusNode: focusNode,
                            onFieldSubmitted: (val) {},
                            maxLines: 10,
                            style: AppConfig.textStyle
                                .poppins()
                                .copyWith(fontSize: 12),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(20.0),
                              hintText: "Write your feedback",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isDense: true,
                              fillColor: Colors.white,
                              filled: true,
                              hintStyle: GoogleFonts.lato(
                                fontSize: 16.0,
                                color: const Color(0xFF1C1C1C).withOpacity(0.6),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: AppConfig.colors.themeColor),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            textCapitalization: TextCapitalization.none,
                            // onChanged: widget.onChange,
                            onEditingComplete: () {
                              // setState(() {
                              //   widget.focusNode.unfocus();
                              // });
                            },
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            // validator:,
                          )),
                    ),
                    SizedBox(height: Get.height * 0.03),
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10, horizontal: Get.width * .03),
                        height: 45,
                        child: GlobalButton(
                            onTap: () {
                              setReviewData(patientProvider);
                              patientProvider.addReview(setRating: setRating);
                              Get.back();
                            },
                            btnColor: AppConfig.colors.themeColor,
                            btnTextColor: Colors.white,
                            buttonText: "Add feedback"),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      );
    });
  }

  void setReviewData(patientProvider) {
    setRating.behaviour = patientProvider.behaviourRating;
    setRating.facility = patientProvider.facilityRating;
    setRating.checkup = patientProvider.checkupRating;
    setRating.feedback = feedBackCon.text;
    setRating.overAllRating = ((patientProvider.behaviourRating +
            patientProvider.checkupRating +
            patientProvider.facilityRating) /
        3);
    setRating.ratedAt = Timestamp.now();
    setRating.ratingId = AppUtils.getFreshTimeStamp();

    setRating.ratedBy =
        "${Provider.of<AuthProvider>(Get.context!, listen: false).appUser!.phone!}";
  }

  Widget reviews(PatientProvider patientProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Behaviour",
                style: TextStyle(
                    color: AppConfig.colors.themeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: Get.height * 0.023,
                    fontFamily: 'Gilroy'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0),
                child: SmoothStarRating(
                    rating: patientProvider.behaviourRating,
                    allowHalfRating: true,
                    onRatingChanged: (value) {
                      patientProvider.setBehaviourRating(value);
                    },
                    starCount: 5,
                    size: Get.height * 0.05,
                    filledIconData: Icons.star,
                    halfFilledIconData: Icons.star_half,
                    defaultIconData: Icons.star_border,
                    color: Color(0xFFE6C010),
                    borderColor: Color(0xFFE6C010),
                    spacing: 1.0),
              ),
            ],
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Check Up",
                style: TextStyle(
                    color: AppConfig.colors.themeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: Get.height * 0.023,
                    fontFamily: 'Gilroy'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0),
                child: SmoothStarRating(
                    rating: patientProvider.checkupRating,
                    allowHalfRating: true,
                    onRatingChanged: (value) {
                      patientProvider.setCheckupRating(value);
                    },
                    starCount: 5,
                    size: Get.height * 0.05,
                    filledIconData: Icons.star,
                    halfFilledIconData: Icons.star_half,
                    defaultIconData: Icons.star_border,
                    color: Color(0xFFE6C010),
                    borderColor: Color(0xFFE6C010),
                    spacing: 1.0),
              ),
            ],
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Facility",
                style: TextStyle(
                    color: AppConfig.colors.themeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: Get.height * 0.023,
                    fontFamily: 'Gilroy'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0),
                child: SmoothStarRating(
                    rating: patientProvider.checkupRating,
                    allowHalfRating: true,
                    onRatingChanged: (value) {
                      patientProvider.setFacilityRating(value);
                    },
                    starCount: 5,
                    size: Get.height * 0.05,
                    filledIconData: Icons.star,
                    halfFilledIconData: Icons.star_half,
                    defaultIconData: Icons.star_border,
                    color: Color(0xFFE6C010),
                    borderColor: Color(0xFFE6C010),
                    spacing: 1.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
