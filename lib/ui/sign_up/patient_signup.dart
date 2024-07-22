import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/modal/user_data.dart';
import 'package:docsheli/providers/auth.dart';
import 'package:docsheli/providers/doctor.dart';
import 'package:docsheli/providers/patient.dart';
import 'package:docsheli/ui/shared/globals/global_classes.dart';
import 'package:docsheli/ui/shared/globals/global_variables.dart';
import 'package:docsheli/utils/enums.dart';
import 'package:docsheli/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PatientSignUp extends StatefulWidget {
  final bool isProfile;
  final String appBarTitle, subTitle;
  final UserData? profileData;

  PatientSignUp(
      {required this.appBarTitle,
      required this.subTitle,
      this.isProfile = false,
      this.profileData});

  @override
  _PatientSignUpState createState() => _PatientSignUpState();
}

class _PatientSignUpState extends State<PatientSignUp> {
  final GlobalKey<FormState> signUpFromKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  final FocusNode fullNameFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();

  final FocusNode dateOfBirthFocusNode = FocusNode();

  @override
  void initState() {
    if (!widget.isProfile) {
      phoneNumberController = TextEditingController(
          text: Provider.of<AuthProvider>(context, listen: false)
                  .appUser
                  ?.phone ??
              "");
    } else {
      fullNameController =
          TextEditingController(text: widget.profileData?.name ?? "");
      dateOfBirthController =
          TextEditingController(text: widget.profileData?.dob ?? "");
      phoneNumberController =
          TextEditingController(text: widget.profileData?.phone ?? "");
      Provider.of<DoctorProvider>(context, listen: false).genderSelected =
          (widget.profileData?.isMale ?? false) ? 0 : 1;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthProvider, PatientProvider, DoctorProvider>(
        builder: (context, model, p, d, _) {
      return Scaffold(
          bottomNavigationBar: widget.isProfile
              ? SizedBox()
              : Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10, horizontal: Get.width * .03),
                  height: 45,
                  child: GlobalButton(
                      onTap: () {
                        if (signUpFromKey.currentState!.validate()) {
                          onPatientSignUpTapped(model);
                          // isDoctor = false;
                        }
                      },
                      btnColor: AppConfig.colors.themeColor,
                      btnTextColor: Colors.white,
                      buttonText: "Get Started"),
                ),
          appBar: AppBar(
            backgroundColor: AppConfig.colors.themeColor,
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: widget.isProfile
                ? IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_ios_outlined,
                        color: Colors.white),
                  )
                : null,
            title: Text(
              widget.appBarTitle,
              style: AppConfig.textStyle.poppins().copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          body: Container(
              margin: EdgeInsets.only(top: 10),
              child: ListView(
                children: [
                  _topUserImgMainCard(d),
                  _mainSignUpPage(context, d),
                  _genderSelectionMainCard(d),
                ],
              )));
    });
  }

  Widget _topUserImgMainCard(DoctorProvider model) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * .05),
      child: Row(
        children: [
          Text(
            widget.subTitle,
            style: AppConfig.textStyle.poppins().copyWith(
                fontSize: Get.width * .055,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: widget.isProfile
                    ? () {}
                    : () {
                        model.getImage();
                      },
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                      )),
                  height: 80,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        (model.userImage != null && widget.isProfile == false)
                            ? FileImage(model.userImage!) as ImageProvider
                            : (widget.profileData?.imageUrl != null &&
                                    widget.isProfile == true)
                                ? NetworkImage((widget.profileData!.imageUrl!))
                                    as ImageProvider
                                : AssetImage(AppConfig.images.addImgIcon2),
                    radius: 30,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        color: Colors.black,
                      )),
                  child: Icon(
                    Icons.camera_alt,
                    size: 18,
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget _mainSignUpPage(BuildContext context, DoctorProvider model) {
    return Form(
      key: signUpFromKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          GlobalFormField(
            label: "Full Name",
            hint: "Name",
            prefixIcon: AppConfig.images.person,
            controller: fullNameController,
            focusNode: fullNameFocusNode,
            nextNode: phoneNumberFocusNode,
            type: TextInputType.text,
            action: TextInputAction.next,
            capitalization: TextCapitalization.sentences,
            validator: (value) =>
                FieldValidator.validateFullName(fullNameController.text),
            regExp: "[a-z A-Z]",
            allow: true,
            textLimit: 25,
          ),
          GlobalFormField(
            label: "Phone Number",
            hint: "Phone No.",
            prefixIcon: AppConfig.images.phoneNoIcon,
            controller: phoneNumberController,
            focusNode: phoneNumberFocusNode,

            type: TextInputType.number,
            action: TextInputAction.next,
            // validator: (value) =>
            //     FieldValidator.validatePhoneNumber(phoneNumberController.text),
            // regExp: "[0-9]",
            allow: true,
            isReadOnly: true,
            textLimit: 15,
          ),
          GlobalFormField(
            label: "Date of Birth",
            hint: "Date of Birth",
            prefixIcon: AppConfig.images.birthdayIcon,
            controller: dateOfBirthController,
            focusNode: dateOfBirthFocusNode,
            isReadOnly: true,
            onTap: () {
              model.selectDateOfBirthFunction(context, dateOfBirthController);
            },
            textStyle: AppConfig.textStyle.poppins().copyWith(
                fontSize: Get.width * .04, fontWeight: FontWeight.bold),
            validator: (value) =>
                FieldValidator.validateDateOfBirth(dateOfBirthController.text),
          ),
        ],
      ),
    );
  }

  Widget _genderSelectionButton(
      int index, DoctorProvider model, String title, img) {
    return GestureDetector(
      onTap: () {
        model.genderSelectedFunc(index);
      },
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: Get.width * .07),
        margin: EdgeInsets.only(bottom: 10),
        width: Get.width * .44,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                color: model.genderSelected == index
                    ? Colors.black
                    : AppConfig.colors.hintColor)),
        child: Row(
          children: [
            SizedBox(
                height: 25,
                child: Image.asset(img,
                    color: model.genderSelected == index
                        ? Colors.black
                        : AppConfig.colors.hintColor)),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: AppConfig.textStyle.poppins().copyWith(
                  fontSize: Get.width * .04,
                  color: model.genderSelected == index
                      ? Colors.black
                      : AppConfig.colors.hintColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderSelectionButtonEdit(
      int index, DoctorProvider model, String title, img) {
    return GestureDetector(
      onTap: () {
        model.genderSelectedFunc(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProfileAvatar(
            "",
            child: Image.asset(img),
            borderWidth: 1,
            radius: Get.width * 0.1,
            borderColor: model.genderSelected == index
                ? Color(0xffF81300)
                : AppConfig.colors.themeColor,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: AppConfig.textStyle.poppins().copyWith(
                fontSize: Get.width * .04,
                color: model.genderSelected == index
                    ? Colors.black
                    : AppConfig.colors.hintColor),
          ),
        ],
      ),
    );
  }

  Widget _genderSelectionMainCard(DoctorProvider model) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Which one are You?",
              style: AppConfig.textStyle.poppins().copyWith(
                    fontSize: 18.0,
                    color: const Color(0xFF1C1C1C),
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.isProfile
                  ? _genderSelectionButtonEdit(
                      0, model, "Male", AppConfig.images.signUpMale)
                  : _genderSelectionButton(
                      0, model, "Male", AppConfig.images.male),
              SizedBox(
                width: !widget.isProfile ? 8 : Get.width * 0.1,
              ),
              widget.isProfile
                  ? _genderSelectionButtonEdit(
                      1, model, "Female", AppConfig.images.signUpFemale)
                  : _genderSelectionButton(
                      1, model, "Female", AppConfig.images.female),
            ],
          ),
        ],
      ),
    );
  }

//methods
  void onPatientSignUpTapped(AuthProvider p) async {
    print("parent signup ");
    p.appUser = UserData(
        name: fullNameController.text,
        role: isDoctor ? Enums.role.doctor : Enums.role.patient,
        dob: dateOfBirthController.text,
        phone: phoneNumberController.text,
        isMale: true,
        createAt: Timestamp.now());

    p.createUserInDB(
      Provider.of<DoctorProvider>(context, listen: false).userImage,
    );
  }
}
