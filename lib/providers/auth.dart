import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docsheli/Services/Speciality/specialitySevices.dart';
import 'package:docsheli/Services/auth.dart';
import 'package:docsheli/Services/shared/firestorage_service.dart';
import 'package:docsheli/constants/firebase_collections.dart';
import 'package:docsheli/modal/doctor_info.dart';
import 'package:docsheli/modal/specialityModal.dart';
import 'package:docsheli/modal/user_data.dart';
import 'package:docsheli/providers/patient.dart';
import 'package:docsheli/ui/patient/dashboard.dart';
import 'package:docsheli/ui/shared/globals/global_variables.dart';
import 'package:docsheli/ui/shared/main_selection.dart';
import 'package:docsheli/ui/shared/verification_code.dart';
import 'package:docsheli/ui/sign_up/doctor_signup.dart';
import 'package:docsheli/ui/sign_up/patient_signup.dart';
import 'package:docsheli/utils/app_user.dart';
import 'package:docsheli/utils/enums.dart';
import 'package:docsheli/utils/routes.dart';
import 'package:docsheli/utils/show_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  AuthServices _authServices = AuthServices();
  FStorageServices fStorage = FStorageServices();
  UserData? appUser;

  DoctorInfo? doctorInfo;
  String imageUrlToSet = '';
  String phoneNumberToSet = '';
  List<SpecialityModal> specialities = [];
  bool isLoading = false;

  StreamSubscription? _specialityStream;

  String pinNumber = "";

  void onInit() {
    getSpeciality();
  }

  void setPinNumber(String num) {
    pinNumber = num;
    print("Pin number is $pinNumber");
    notifyListeners();
  }

  void verifyNumber({required String phoneNumber}) async {
    debugPrint("sending code on $phoneNumber");
    try {
      startLoader();
      await _authServices.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          onSent: (String verificationId) {
            Get.to(() => VerificationCode(verificationId));
          });
    } catch (e) {
      print(e.toString());
    } finally {
      stopLoader();
    }
  }

  void verifyOTP({required String verificationId}) async {
    startLoader();
    User? user =
        await _authServices.signInWithPhoneNumber(pinNumber, verificationId);
    stopLoader();
    if (user != null) {
      appUser = UserData(
          phone: user.phoneNumber,
          role: isDoctor ? Enums.role.doctor : Enums.role.patient);
      navigateByRole(user);
    }
  }

  void navigateByRole(User user) async {
// read user data then check whether the user is already fully registered or not,
// and navigate according to the role.
    try {
      UserData? userData =
          await _authServices.getUserById(user.phoneNumber ?? "");
      print("user data after getting user from if is $userData");

      if (userData == null) {
        Get.to(() => isDoctor
            ? DoctorSignUp(
                appBarTitle: "Complete Profile",
                subTitle: "Sign Up",
                isEditProfile: false,
              )
            : PatientSignUp(
                appBarTitle: "Complete Profile",
                subTitle: "Sign Up",
                isProfile: false,
              ));
      } else {
        appUser = userData;
        AppUser.user = userData;
        isDoctor = appUser?.role == UserRole().doctor;
        if (userData.role == Enums.role.patient) {
          Get.offAll(() => DashBoardPatient());
        } else {
          await navigateToDoctor();
        }
      }
    } catch (e) {
      print(e.toString());
      AppRoutes.makeFirst(Get.context!!, MainSelection());
    }
  }

  Future<void> navigateToDoctor() async {
    stopLoader();
    DocumentReference documentReference =
        FBCollections.users.doc(appUser?.phone);
    DoctorInfo? doc = await _authServices.getDoctorByDocRef(documentReference);
    stopLoader();
    if (doc == null || doc.userRef == null) {
      AppRoutes.push(Get.context!,
          DoctorSignUp(appBarTitle: "Doctor Signup", subTitle: "profile"));
    } else {
      doctorInfo = doc;
      AppUser.currentDoctor = doc;
      AppRoutes.makeFirst(Get.context!, DashBoardPatient());
    }
  }

  void createUserInDB(File? imageFile, {DoctorInfo? doc}) async {
    print("createUserInDB is doc =$isDoctor");
    if (imageFile != null) {
      startLoader();
      imageUrlToSet = await fStorage.uploadSingleFile(
          bucketName: "Profile Images",
          file: imageFile,
          userId: appUser?.phone ?? "");
      stopLoader();
    }

    startLoader();

    if (doc != null) {
      await registerDoctor(doc);
    } else {
      appUser?.isActive = true;
      await registerPatient();
    }

    if (appUser?.phone != null) {
      appUser = await _authServices.getUserById(appUser!.phone);
      AppUser.user = appUser;
    }

    stopLoader();
    isDoctor
        ? AppRoutes.push(Get.context!, DashBoardPatient())
        : Get.offAll(() => DashBoardPatient());
  }

  Future<void> registerUser() async {
    try {
      startLoader();
      appUser?.imageUrl = imageUrlToSet;
      appUser?.createAt = Timestamp.now();
      await _authServices.setUserData(
          phoneNumber: appUser!.phone!, payload: appUser!.toJson());
      AppUser.user = appUser;
      stopLoader();
    } catch (e) {
      stopLoader();
      ShowMessage.showToast(msg: e.toString(), isError: true);
    }
  }

  Future<void> registerDoctor(DoctorInfo doc) async {
    startLoader();
    UserData? userData = await _authServices.getUserById(appUser?.phone);
    stopLoader();
    if (userData == null) {
      appUser?.isActive = true;
      await registerUser();
    } else {
      appUser = userData;
    }

    stopLoader();

    await FBCollections.doctorsInfo.doc(appUser!.phone!).set(doc.toJson());
    DoctorInfo? doctor = await _authServices.getDoctorById(appUser!.phone!);
    if (doctor != null) {
      doctorInfo = doctor;
      AppUser.currentDoctor = doctor;
      AppRoutes.push(Get.context!, DashBoardPatient());
    }
  }

  Future<void> registerPatient() async {
    startLoader();
    UserData? userData = await _authServices.getUserById(appUser!.phone!);
    stopLoader();
    if (userData == null) {
      appUser?.isActive = true;
      await registerUser();
    } else {
      appUser = userData;
      AppUser.user = userData;
    }
  }

  Future<void> checkCurrentUser() async {
    startLoader();
    User? user = await _authServices.getCurrentUser();
    stopLoader();
    if (user == null) {
      AppRoutes.makeFirst(Get.context!, MainSelection());
    } else {
      navigateByRole(user);
    }
  }

  Future<void> getSpeciality() async {
    startLoader();

    specialities = await SpecialityServices().getSpecialities();

    stopLoader();
    notifyListeners();
  }

  //update
  Future<void> updateUserProfile(UserData u, File? imageFile) async {
    stopLoader();
    if (imageFile != null) {
      imageUrlToSet = await fStorage.uploadSingleFile(
          bucketName: "Profile Images",
          file: imageFile,
          userId: appUser!.phone!);
      stopLoader();
      u.imageUrl = imageUrlToSet;
    }
    _authServices.updateUserData(userEmail: u.phone!, payload: u.toJson());
    AppUser.user = await _authServices.getUserById(u.phone);
    appUser = AppUser.user;
    stopLoader();
  }

  Future<void> updateDoctorProfile(DoctorInfo doc) async {
    stopLoader();
    await FBCollections.doctorsInfo.doc(doc.userId).update(doc.toJson());
    AppUser.currentDoctor =
        await Provider.of<PatientProvider>(Get.context!, listen: false)
            .getDoctorInfo(doc.userId);
    stopLoader();
  }

  signOut() async {
    await _authServices.signOut();
  }

  startLoader() {
    isLoading = true;
    notifyListeners();
  }

  stopLoader() {
    isLoading = false;
    notifyListeners();
  }

  disposeStream() {
    _specialityStream?.cancel();
    _specialityStream = null;
  }
}
