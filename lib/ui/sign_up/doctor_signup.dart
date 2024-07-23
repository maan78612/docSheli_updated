import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/constants/firebase_collections.dart';
import 'package:docsheli/modal/doctor_info.dart';
import 'package:docsheli/modal/specialityModal.dart';
import 'package:docsheli/modal/user_data.dart';
import 'package:docsheli/providers/auth.dart';
import 'package:docsheli/providers/doctor.dart';
import 'package:docsheli/ui/shared/globals/global_classes.dart';
import 'package:docsheli/ui/shared/globals/global_variables.dart';
import 'package:docsheli/utils/app_user.dart';
import 'package:docsheli/utils/enums.dart';
import 'package:docsheli/utils/show_message.dart';
import 'package:docsheli/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class DoctorSignUp extends StatefulWidget {
  final bool isEditProfile;

  final String appBarTitle, subTitle;

  DoctorSignUp({
    required this.appBarTitle,
    required this.subTitle,
    this.isEditProfile = false,
  });

  @override
  _DoctorSignUpState createState() => _DoctorSignUpState();
}

class _DoctorSignUpState extends State<DoctorSignUp> {
  final GlobalKey<FormState> signUpFromKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController specialityController = TextEditingController();
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController experienceCont = TextEditingController();
  final FocusNode fullNameFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();
  final FocusNode qualificationFocusNode = FocusNode();
  final FocusNode licenseFocusNode = FocusNode();
  final FocusNode experienceFN = FocusNode();
  final FocusNode specialityFocusNode = FocusNode();
  final FocusNode hospitalFocusNode = FocusNode();
  final FocusNode dateOfBirthFocusNode = FocusNode();

  List<String> daysList = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
  List<String> selectedDays = [];
  List<String> selectedTimes = [];
  SpecialityModal? selectedSpeciality;

  @override
  void initState() {
    AuthProvider p = Provider.of<AuthProvider>(context, listen: false);

    phoneNumberController = TextEditingController(text: p.appUser?.phone ?? "");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DoctorProvider>(context, listen: false).setTimeSlots(context);
    });

    fillEditForm(p);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, DoctorProvider>(
        builder: (context, model, d, _) {
      return LoadingOverlay(
        isLoading: model.isLoading || d.isLoading,
        child: Scaffold(
            bottomNavigationBar: Container(
              margin: EdgeInsets.symmetric(
                  vertical: 10, horizontal: Get.width * .03),
              height: 45,
              child: GlobalButton(
                  onTap: () => widget.isEditProfile
                      ? updateDoctorProfile(model)
                      : onDoctorSignUpTapped(model),
                  btnColor: AppConfig.colors.themeColor,
                  btnTextColor: Colors.white,
                  buttonText:
                      widget.isEditProfile ? "Update Profile" : "Get Started"),
            ),
            appBar: !widget.isEditProfile
                ? PreferredSize(
                    child: Container(), preferredSize: Size.fromHeight(0))
                : AppBar(
                    backgroundColor: AppConfig.colors.themeColor,
                    centerTitle: true,
                    automaticallyImplyLeading: widget.isEditProfile,
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
                    _topUserImgMainCard(model),
                    _mainSignUpPage(context, model),
                    _genderSelectionMainCard(model),
                    _timeSlotsMainCard(model, d)
                  ],
                ))),
      );
    });
  }

  Widget _topUserImgMainCard(AuthProvider model) {
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
                onTap: () {
                  Provider.of<DoctorProvider>(context, listen: false)
                      .getImage();
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
                    backgroundImage: (Provider.of<DoctorProvider>(context,
                                    listen: false)
                                .userImage !=
                            null)
                        ? FileImage(
                            Provider.of<DoctorProvider>(context, listen: false)
                                .userImage!) as ImageProvider
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

  // main sign up card
  Widget _mainSignUpPage(BuildContext context, AuthProvider model) {
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
            nextNode: qualificationFocusNode,
            type: TextInputType.number,
            action: TextInputAction.next,
            // validator: (value) =>
            //     FieldValidator.validatePhoneNumber(phoneNumberController.text),
            regExp: "[+ 0-9]",
            isReadOnly: phoneNumberController.text.isNotEmpty,
            allow: true,
            textLimit: 15,
          ),
          GlobalFormField(
            label: "Qualification",
            hint: "Degree Details",
            prefixIcon: AppConfig.images.qualificationIcon,
            controller: qualificationController,
            focusNode: qualificationFocusNode,
            nextNode: licenseFocusNode,
            type: TextInputType.text,
            action: TextInputAction.next,
            validator: (value) => FieldValidator.validateQualification(
                qualificationController.text),
            textLimit: 100,
          ),
          GlobalFormField(
            label: "License Number",
            hint: "License Number",
            controller: licenseController,
            focusNode: licenseFocusNode,
            nextNode: experienceFN,
            type: TextInputType.text,
            action: TextInputAction.next,
            validator: (value) =>
                FieldValidator.validateLicenseNumber(licenseController.text),
            textLimit: 100,
          ),
          GlobalFormField(
            label: "Experience",
            hint: "in years",
            prefixIcon: AppConfig.images.specialityIcon,
            controller: experienceCont,
            focusNode: experienceFN,
            nextNode: hospitalFocusNode,
            type: TextInputType.phone,
            inputFormatter: [FilteringTextInputFormatter.digitsOnly],
            action: TextInputAction.next,
            validator: FieldValidator.validateExp,
            textLimit: 100,
          ),
          GlobalFormField(
            label: "Hospital",
            hint: "Hospital Details",
            prefixIcon: AppConfig.images.hospitalIcon,
            controller: hospitalController,
            focusNode: hospitalFocusNode,
            nextNode: dateOfBirthFocusNode,
            type: TextInputType.text,
            action: TextInputAction.next,
            validator: (value) =>
                FieldValidator.validateHospital(hospitalController.text),
            textLimit: 100,
          ),
          GlobalFormField(
            label: "Date of Birth",
            hint: "Date of Birth",
            prefixIcon: AppConfig.images.birthdayIcon,
            controller: dateOfBirthController,
            focusNode: dateOfBirthFocusNode,
            isReadOnly: true,
            onTap: () {
              Provider.of<DoctorProvider>(context, listen: false)
                  .selectDateOfBirthFunction(context, dateOfBirthController);
            },
            textStyle: AppConfig.textStyle.poppins().copyWith(
                fontSize: Get.width * .04, fontWeight: FontWeight.bold),
            validator: (value) =>
                FieldValidator.validateDateOfBirth(dateOfBirthController.text),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Speciality",
                    style: AppConfig.textStyle.poppins().copyWith(
                        color: AppConfig.colors.hintColor,
                        fontSize: Get.width * .035,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                DropdownButtonFormField<SpecialityModal>(
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      isDense: true,
                      hintText: "Speciality",
                      prefixIcon: Container(
                        margin: EdgeInsets.all(12),
                        height: 10,
                        width: 10,
                        child: Image.asset(
                          AppConfig.images.specialityIcon,
                        ),
                      ),
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      filled: true,
                      hintStyle: AppConfig.textStyle.poppins().copyWith(
                          fontSize: 13, color: AppConfig.colors.hintColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                            BorderSide(color: AppConfig.colors.iconGrey),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                            BorderSide(color: AppConfig.colors.iconGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                            BorderSide(color: AppConfig.colors.themeColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      errorStyle: AppConfig.textStyle
                          .poppins()
                          .copyWith(color: Colors.red, fontSize: 10)),
                  items: List.generate(model.specialities.length, (index) {
                    SpecialityModal sp = model.specialities[index];
                    return DropdownMenuItem(
                      child: Text(sp.speciality ?? ""),
                      value: sp,
                    );
                  }),
                  value: selectedSpeciality,
                  onChanged: (sp) {
                    setState(() {
                      selectedSpeciality = sp;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // gender selection button
  Widget _genderSelectionButton(int index, String title, img) {
    var model = Provider.of<DoctorProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        setState(() {
          model.genderSelectedFunc(index);
        });
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

  // gender selection main card
  Widget _genderSelectionMainCard(AuthProvider model) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Which one are You?",
              style: AppConfig.textStyle
                  .poppins()
                  .copyWith(color: AppConfig.colors.hintColor, fontSize: 12),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _genderSelectionButton(0, "Male", AppConfig.images.male),
              SizedBox(
                width: 8,
              ),
              _genderSelectionButton(1, "Female", AppConfig.images.female),
            ],
          ),
        ],
      ),
    );
  }

// Widget for time slot buttons
  Widget _buildTimeSlotButton(
      String title, bool isSelected, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              spreadRadius: 2,
              blurRadius: 3,
              color: Colors.black.withOpacity(.06),
            ),
          ],
          color: isSelected ? AppConfig.colors.themeColor : Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        height: 35,
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time,
                color: isSelected ? Colors.white : Colors.black,
                size: 15,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: AppConfig.textStyle.poppins().copyWith(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 13,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Function to build time slot rows
  List<Widget> _buildTimeSlots(List<String> times, bool isMorning) {
    List<Widget> rows = [];
    for (int i = 0; i < times.length; i += 3) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (index) {
            int currentIndex = i + index;
            if (currentIndex < times.length) {
              return Expanded(
                child: _buildTimeSlotButton(
                  times[currentIndex],
                  selectedTimes.contains(times[currentIndex]),
                  () {
                    setState(() {
                      if (!selectedTimes.contains(times[currentIndex])) {
                        selectedTimes.add(times[currentIndex]);
                      } else {
                        selectedTimes.remove(times[currentIndex]);
                      }
                    });
                  },
                ),
              );
            } else {
              return Expanded(child: SizedBox.shrink());
            }
          }),
        ),
      );
    }
    return rows;
  }

// Widget for the time slots main card
  Widget _timeSlotsMainCard(AuthProvider model, DoctorProvider docProvider) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * .05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            "Time Slots",
            style: AppConfig.textStyle.poppins().copyWith(
                  fontSize: Get.width * .05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: daysList.map((day) {
                bool isSelected = selectedDays.contains(day);
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedDays.remove(day);
                        } else {
                          selectedDays.add(day);
                        }
                      });
                    },
                    child: Container(
                      height: 72,
                      width: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? AppConfig.colors.themeColor
                            : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Morning",
            style: AppConfig.textStyle.poppins().copyWith(
                  fontSize: Get.width * .04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          Column(
            children: _buildTimeSlots(docProvider.morningTimes, true),
          ),
          SizedBox(height: 15),
          Text(
            "Evening",
            style: AppConfig.textStyle.poppins().copyWith(
                  fontSize: Get.width * .04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          Column(
            children: _buildTimeSlots(docProvider.eveningTimes, false),
          ),
        ],
      ),
    );
  }

  //methods
  void onDoctorSignUpTapped(AuthProvider p) async {
    print(selectedDays);
    print(selectedTimes);
    if (selectedTimes.isEmpty || selectedDays.isEmpty) {
      return ShowMessage.showToast(
          msg: "Please select your days and time slots", isError: true);
    }
    if (selectedSpeciality == null) {
      return ShowMessage.showToast(
          msg: "Please select your speciality", isError: true);
    }
    p.appUser = UserData(
        name: fullNameController.text,
        role: isDoctor ? Enums.role.doctor : Enums.role.patient,
        dob: dateOfBirthController.text,
        phone: phoneNumberController.text,
        isMale: true,
        createAt: Timestamp.now());

    DocumentReference ref = FBCollections.users.doc(p.appUser!.phone!);
    DoctorInfo docInfo = DoctorInfo(
      hospital: hospitalController.text,
      userId: p.appUser!.phone!,
      qualification: qualificationController.text,
      experience: int.parse(experienceCont.text ?? ""),
      availableSlots: selectedTimes,
      availableDays: selectedDays,
      specialityId: selectedSpeciality?.id ?? "",
      license: licenseController.text,
      userRef: ref,
    );
    AppUser.currentDoctor = docInfo;
    p.createUserInDB(
        Provider.of<DoctorProvider>(context, listen: false).userImage,
        doc: isDoctor ? docInfo : null);
  }

  void updateUser(AuthProvider p) async {
    await p.updateUserProfile(p.appUser!,
        Provider.of<DoctorProvider>(context, listen: false).userImage);
  }

  void updateDoctorProfile(AuthProvider p) async {
    try {
      updateUser(p);
      if (p.appUser != null) {
        DocumentReference ref = FBCollections.users.doc(p.appUser!.phone);
        DoctorInfo docInfo = DoctorInfo(
          hospital: hospitalController.text,
          userId: p.appUser!.phone!,
          qualification: qualificationController.text,
          experience: int.parse(experienceCont.text),
          availableSlots: selectedTimes,
          availableDays: selectedDays,
          specialityId: selectedSpeciality?.id ?? "",
          license: licenseController.text,
          userRef: ref,
        );
        await p.updateDoctorProfile(docInfo);
        ShowMessage.showToast(msg: "Profile update successfully");
      }
    } catch (e) {
      print(e.toString());
    } finally {
      Get.back();
    }
  }

  @override
  void dispose() {
    AuthProvider p = Provider.of<AuthProvider>(context, listen: false);
    p.dispose();
    super.dispose();
  }

  // fill editForm

  void fillEditForm(AuthProvider p) {
    if (!widget.isEditProfile) return;
    if (AppUser.user == null) return;
    UserData user = AppUser.user!;
    DoctorInfo doctor = AppUser.currentDoctor!;
    fullNameController.text = user.name ?? "";
    phoneNumberController.text = user.phone ?? "";
    qualificationController.text = doctor.qualification ?? "";
    experienceCont.text = "${doctor.experience ?? ""}";
    hospitalController.text = doctor.hospital ?? "";
    licenseController.text = doctor.license ?? "";
    dateOfBirthController.text = user.dob ?? "";
    SpecialityModal? spId = p.specialities
            .where((element) => doctor.specialityId == element.id)
            .isEmpty
        ? null
        : p.specialities
            .where((element) => doctor.specialityId == element.id)
            .first;
    selectedSpeciality = spId;
    selectedTimes.clear();
    selectedTimes.addAll(doctor.availableSlots.toList());
    selectedDays.clear();
    selectedDays.addAll(doctor.availableDays.toList());
  }
}
