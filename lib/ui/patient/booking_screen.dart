import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/modal/doctor_info.dart';
import 'package:docsheli/modal/dropDown.dart';
import 'package:docsheli/modal/specialityModal.dart';
import 'package:docsheli/modal/user_data.dart';
import 'package:docsheli/providers/auth.dart';
import 'package:docsheli/providers/patient.dart';
import 'package:docsheli/ui/patient/select_booking_time.dart';
import 'package:docsheli/utils/app_user.dart';
import 'package:docsheli/utils/app_utils.dart';
import 'package:docsheli/utils/enums.dart';
import 'package:docsheli/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BookAppointment extends StatefulWidget {
  final bool isVideo;
  final DoctorInfo doc;
  final SpecialityModal sp;
  final UserData doctorInfo;

  BookAppointment(
      {required this.isVideo,
      required this.doc,
      required this.doctorInfo,
      required this.sp});

  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  final GlobalKey<FormState> bookingFromKey = GlobalKey<FormState>();
  List<DropDownbookingAppointment> dropDownData = [];
  bool isMale = true;

  @override
  void initState() {
    dropDownData.clear();
    dropDownData = [
      DropDownbookingAppointment(id: 1, value: "Father"),
      DropDownbookingAppointment(id: 2, value: "Mother"),
      DropDownbookingAppointment(id: 3, value: "Brother"),
      DropDownbookingAppointment(id: 1, value: "Sister"),
      DropDownbookingAppointment(id: 1, value: "Other"),
    ];
    super.initState();
  }

  UserData? user;
  DoctorInfo? doctor;
  SpecialityModal? sp;

  @override
  void didChangeDependencies() {
    user = widget.doctorInfo;
    doctor = widget.doc;
    sp = widget.sp;
    Future.delayed(Duration(milliseconds: 200), () {
      PatientProvider p = Provider.of<PatientProvider>(context, listen: false);
      p.clear();
      p.nameCon.text = AppUser.user?.name ?? "";
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProvider>(builder: (context, model, _) {
      bool noImage =
          widget.doctorInfo.imageUrl == null || (user?.imageUrl ?? "").isEmpty;
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
                'Enter Patient Details',
                style: GoogleFonts.roboto(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                margin: EdgeInsets.only(top: Get.height * 0.025),
                // height: Get.height * 0.9,
                color: AppConfig.colors.lightBlue,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: Get.height * 0.02),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProfileAvatar(
                            noImage ? AppUtils.userAvatar : user!.imageUrl!,
                            borderWidth: 1,
                            radius: Get.width * 0.1,
                            borderColor: AppConfig.colors.themeColor,
                          ),
                          SizedBox(width: Get.width * .04),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user?.name ?? "-"}',
                                style: GoogleFonts.roboto(
                                  fontSize: 20.0,
                                  color: const Color(0xFF19769F),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "${sp?.speciality ?? ""}",
                                style: GoogleFonts.roboto(
                                  fontSize: 14.0,
                                  color: const Color(0xFF51565F),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: Get.height * 0.008),
                              Text(
                                '${doctor?.qualification ?? ""}',
                                style: TextStyle(
                                  fontFamily: 'Gotham Rounded',
                                  fontSize: 14.0,
                                  color: const Color(0xFF51565F),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(height: Get.height * 0.005),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: Get.height * 0.025),
                      Divider(
                        thickness: 1,
                        // color: AppConfig.colors.dividerClr,
                        indent: Get.width * 0.07,
                        endIndent: Get.width * 0.07,
                      ),
                      SizedBox(height: Get.height * 0.04),
                      bookingFor(model),
                      Form(
                        key: bookingFromKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            textFormFieldCustom(
                                label: "Full name",
                                model: model,
                                controller: model.nameCon,
                                focusNode: model.nameFocus,
                                image: AppConfig.images.person,
                                hint: "Enter your name"),
                            if (model.isSomeOne)
                              SizedBox(height: Get.height * 0.01),
                            if (model.isSomeOne)
                              textFormFieldCustom(
                                  label: "Phone",
                                  model: model,
                                  focusNode: model.numberFocus,
                                  controller: model.numberCon,
                                  image: AppConfig.images.phone,
                                  hint: "Enter your number"),
                          ],
                        ),
                      ),
                      SizedBox(height: Get.height * 0.01),
                      if (model.isSomeOne)
                        dropDownCustom("Relationship", model),
                      gender(model),
                      confirmBooking(model),
                    ]),
              ),
            ),
          ));
    });
  }

  Widget bookingFor(PatientProvider model) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: Get.width * .1, vertical: Get.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: Get.width * .08),
              child: Text(
                "Booking For?",
                style: TextStyle(
                  fontFamily: 'Ebrima',
                  fontSize: 12.0,
                  color: const Color(0xFF1C1C1C),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.008),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    model.bookingType(false);
                  },
                  child: Container(
                      width: Get.width * 0.35,
                      height: Get.height * 0.05,
                      decoration: BoxDecoration(
                          color: model.isSomeOne
                              ? AppConfig.colors.lightBlue
                              : Colors.white,
                          border: Border.all(
                            color: Color(0xff707070),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!model.isSomeOne)
                            Image.asset(AppConfig.images.tick,
                                scale: 3, color: Colors.black),
                          if (!model.isSomeOne) SizedBox(width: 10),
                          Text(
                            'Myself',
                            style: TextStyle(
                              fontFamily: 'Ebrima',
                              fontSize: 15.0,
                              color: const Color(0xFF1C1C1C),
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      )),
                ),
                SizedBox(width: Get.width * 0.02),
                GestureDetector(
                  onTap: () {
                    model.bookingType(true);
                  },
                  child: Container(
                      width: Get.width * 0.35,
                      height: Get.height * 0.05,
                      decoration: BoxDecoration(
                          color: model.isSomeOne
                              ? Colors.white
                              : AppConfig.colors.lightBlue,
                          border: Border.all(
                            color: Color(0xff707070),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (model.isSomeOne)
                            Image.asset(AppConfig.images.tick,
                                scale: 3, color: Colors.black),
                          if (model.isSomeOne) SizedBox(width: 10),
                          Text(
                            'Someone else',
                            style: TextStyle(
                              fontFamily: 'Ebrima',
                              fontSize: 15.0,
                              color: const Color(0xFF1C1C1C),
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      )),
                ),
              ],
            )
          ],
        ));
  }

  Widget textFormFieldCustom(
      {required String label,
      required PatientProvider model,
      required TextEditingController controller,
      required FocusNode focusNode,
      required String image,
      required String hint}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              left: Get.width * .06,
              right: Get.width * .05,
              bottom: Get.height * 0.007),
          child: Text(
            label,
            style: AppConfig.textStyle.poppins().copyWith(
                color: Color(0xFF1C1C1C),
                fontSize: Get.width * .025,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
            margin: EdgeInsets.only(
              left: Get.width * .05,
              right: Get.width * .05,
            ),
            width: Get.width * 0.78,
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
              controller: controller,
              focusNode: focusNode,
              style: AppConfig.textStyle.poppins().copyWith(fontSize: 12),
              decoration: InputDecoration(
                hintText: hint,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                isDense: true,
                prefixIcon: Container(
                  height: 10,
                  width: 10,
                  child: Image.asset(
                    image,
                    scale: 3,
                  ),
                ),
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                filled: true,
                hintStyle: AppConfig.textStyle
                    .poppins()
                    .copyWith(fontSize: 12, color: AppConfig.colors.hintColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: AppConfig.colors.themeColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              textCapitalization: TextCapitalization.none,
              // onChanged: widget.onChange,
              onEditingComplete: () {
                setState(() {
                  focusNode.unfocus();
                });
              },
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              validator: (value) =>
                  FieldValidator.validateField(controller.text),
            )),
      ],
    );
  }

  Widget dropDownCustom(String title, PatientProvider model) {
    return Container(
        height: Get.height * 0.1,
        margin: EdgeInsets.symmetric(
            horizontal: Get.width * .1, vertical: Get.height * 0.005),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Ebrima',
                  fontSize: 10.0,
                  color: const Color(0xFF1C1C1C),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: 25,
                  color: Colors.black,
                ),
                dropdownColor: Colors.white,
                items: List.generate(dropDownData.length, (index) {
                  DropDownbookingAppointment data = dropDownData[index];
                  return new DropdownMenuItem(
                    value: data,
                    child: new Text(data.value ?? ""),
                  );
                }),
                hint: Text(
                  "Select",
                  style: TextStyle(color: Colors.black),
                ),
                value: model.relation,
                onChanged: model.selectRelation,
                elevation: 0,
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.black,
            ),
          ],
        ));
  }

  Widget gender(PatientProvider model) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: Get.width * .1, vertical: Get.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: Get.width * .08),
              child: Text(
                "gender",
                style: TextStyle(
                  fontFamily: 'Ebrima',
                  fontSize: 12.0,
                  color: const Color(0xFF1C1C1C),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.008),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isMale = true;
                    });
                  },
                  child: Container(
                      width: Get.width * 0.35,
                      height: Get.height * 0.05,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: isMale == true
                                  ? Colors.black
                                  : AppConfig.colors.hintColor)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppConfig.images.male,
                              scale: 3,
                              color: isMale == true
                                  ? Colors.black
                                  : AppConfig.colors.hintColor),
                          SizedBox(width: 20),
                          Text(
                            'Male',
                            style: TextStyle(
                                fontFamily: 'Ebrima',
                                fontSize: 15.0,
                                color: isMale == true
                                    ? Colors.black
                                    : AppConfig.colors.hintColor),
                            textAlign: TextAlign.center,
                          )
                        ],
                      )),
                ),
                SizedBox(width: Get.width * 0.02),
                InkWell(
                  onTap: () {
                    setState(() {
                      isMale = false;
                    });
                  },
                  child: Container(
                      width: Get.width * 0.35,
                      height: Get.height * 0.05,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: isMale == false
                                  ? Colors.black
                                  : AppConfig.colors.hintColor)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppConfig.images.female,
                              scale: 3,
                              color: isMale == false
                                  ? Colors.black
                                  : AppConfig.colors.hintColor),
                          SizedBox(width: 20),
                          Text(
                            'Female',
                            style: TextStyle(
                                fontFamily: 'Ebrima',
                                fontSize: 15.0,
                                color: isMale == false
                                    ? Colors.black
                                    : AppConfig.colors.hintColor),
                            textAlign: TextAlign.center,
                          )
                        ],
                      )),
                ),
              ],
            )
          ],
        ));
  }

  Widget confirmBooking(PatientProvider model) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: Get.width * .1, vertical: Get.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                child: Text(
              'Confirm Their booking',
              style: TextStyle(
                fontFamily: 'Ebrima',
                fontSize: 15.0,
                color: const Color(0xFF1C1C1C),
              ),
              textAlign: TextAlign.center,
            )),
            SizedBox(height: Get.height * 0.02),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (bookingFromKey.currentState!.validate()) {
                      if (model.isSomeOne == true && model.relation == null) {
                        Get.snackbar("Relationship",
                            "please select relationship to proceed",
                            backgroundColor: Colors.white,
                            colorText: AppConfig.colors.themeColor);
                      } else {
                        model.setAppointment.doctorId = user!.phone!;
                        model.setAppointment.bookingFor = model.isSomeOne
                            ? Enums.bookingFor.someone
                            : Enums.bookingFor.myself;
                        model.setAppointment.fullName = model.nameCon.text;
                        model.setAppointment.phoneNumber = model.numberCon.text;
                        model.setAppointment.paymentStatus = true;
                        model.isSomeOne
                            ? model.setAppointment.relationship =
                                model.relation?.toJson()
                            : model.setAppointment.relationship = null;
                        model.setAppointment.gender =
                            isMale ? Enums.gender.male : Enums.gender.female;
                        model.setAppointment.appointmentType = widget.isVideo
                            ? Enums.appointmentType.videoConsultation
                            : Enums.appointmentType.bookAppointment;
                        model.setAppointment.patientID =
                            Provider.of<AuthProvider>(context, listen: false)
                                    .appUser
                                    ?.phone ??
                                "";

                        print(model.setAppointment.toJson());
                        Get.to(SelectBookingTime(
                          sp: sp,
                          doc: doctor,
                          doctorInfo: user,
                        ));
                      }
                    }
                  },
                  child: Container(
                    width: Get.width * 0.7,
                    height: Get.height * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: const Color(0xFF2A2AC0),
                    ),
                    child: Center(
                      child: Text(
                        'Proceed',
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
            SizedBox(height: Get.height * 0.015),
            Text.rich(
              TextSpan(
                style: TextStyle(
                  fontFamily: 'Ebrima',
                  fontSize: 11.0,
                  color: const Color(0xFF1C1C1C),
                ),
                children: [
                  TextSpan(
                    text:
                        'This will take you to the payment page where you can\npay through your credit or debit card.\n',
                  ),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: ' are applied',
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
