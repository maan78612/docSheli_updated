import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docsheli/Services/AppointmentServices/appointmentServices.dart';
import 'package:docsheli/Services/MedicalRecord/medicalRecord.dart';
import 'package:docsheli/Services/Speciality/specialitySevices.dart';
import 'package:docsheli/constants/firebase_collections.dart';
import 'package:docsheli/modal/appointment.dart';
import 'package:docsheli/modal/doctor_info.dart';
import 'package:docsheli/modal/dropDown.dart';
import 'package:docsheli/modal/medical_record.dart';
import 'package:docsheli/modal/rating.dart';
import 'package:docsheli/modal/specialityModal.dart';
import 'package:docsheli/modal/transactionModal.dart';
import 'package:docsheli/providers/auth.dart';
import 'package:docsheli/ui/patient/payment_confirm.dart';
import 'package:docsheli/ui/shared/globals/global_variables.dart';
import 'package:docsheli/utils/app_user.dart';
import 'package:docsheli/utils/app_utils.dart';
import 'package:docsheli/utils/enums.dart';
import 'package:docsheli/utils/show_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PatientProvider extends ChangeNotifier {
  ///////// Book Appointment (Doctor side)///////////
  TextEditingController nameCon = new TextEditingController();
  TextEditingController numberCon = new TextEditingController();

  FocusNode nameFocus = new FocusNode();
  FocusNode numberFocus = new FocusNode();
  DropDownbookingAppointment? relation;
  bool isSomeOne = false;
  StreamSubscription? _specialityStream;

  ////////////////// Doctor Rating on Patient Side//////////////////
  double behaviourRating = 0.0;
  double checkupRating = 0.0;
  double facilityRating = 0.0;

  void setBehaviourRating(double num) {
    behaviourRating = num;
    print(" Behaviour Rating is :  $behaviourRating");
    notifyListeners();
  }

  void setCheckupRating(double num) {
    checkupRating = num;
    print("Check up Rating is :  $checkupRating");
    notifyListeners();
  }

  void setFacilityRating(double num) {
    facilityRating = num;
    print("Facility Rating is :  $facilityRating");
    notifyListeners();
  }

///////// Book Appointment (Doctor side)///////////

  void selectRelation(value) {
    relation = value;
    print("${relation?.value}");
    notifyListeners();
  }

  void bookingType(bool value) {
    isSomeOne = value;
    print("$isSomeOne");
    notifyListeners();
  }

  void clear() {
    relation = null;
    isSomeOne = false;
    nameCon.clear();
    numberCon.clear();
    notifyListeners();
  }

  ///////////////////////////////////////////////////////////////////////
  //////////////////////////////////BACKEND//////////////////////////////
  ///////////////////////////////////////////////////////////////////////

  bool isLoading = false;

  void startLoader() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoader() {
    isLoading = false;
    notifyListeners();
  }

  //////////============ Get speciality list===============//////////

  onInit() {
    getSpeciality();
  }

  List<SpecialityModal> specialityModalData = [];

  Future<void> getSpeciality() async {
    startLoader();
    specialityModalData = await SpecialityServices().getSpecialities();

    stopLoader();
    notifyListeners();
  }

  onInItDashBoard() async {
    print(
        "\n ====================Dash board User data=========================\n");
    print(
        "${Provider.of<AuthProvider>(Get.context!, listen: false).appUser?.toJson()}");
    var p = Provider.of<AuthProvider>(Get.context!, listen: false);
    if (!isDoctor) {
      onDisposeMedical();
      await getMedicalRecord(
          Provider.of<AuthProvider>(Get.context!, listen: false)
              .appUser!
              .phone!);
    }
    AppUser.user = p.appUser;
    getAppointments();

    notifyListeners();
  }

  List<MedicalRecordModal> medicalRecordList = [];
  StreamSubscription? _streamSubscriptionMedicalRecords;
  StreamSubscription? _streamSubscriptionAppointmentRecords;
  MedicalRecordModal medicalRecord = MedicalRecordModal();

  Future addMedicalRecord({required MedicalRecordModal medicalRecord}) async {
    print("in at medical record add");
    await FBCollections.medicalRecords.doc().set(medicalRecord.toJson());
    stopLoader();
    notifyListeners();
  }

  Future<void> getMedicalRecord(String patientNumber) async {
    print("========== patient number for medical record is $patientNumber");
    var value = await MedicalRecordServices.medicalRecordList("$patientNumber");
    if (_streamSubscriptionMedicalRecords == null) {
      _streamSubscriptionMedicalRecords = value.listen((event) {
        medicalRecordList = event;
        print(
            "length of medical Records of doctor ${medicalRecordList.length} against patient $patientNumber ");
      });
    }
    notifyListeners();
  }

  void onDispose() {
    _streamSubscriptionMedicalRecords?.cancel();
    _streamSubscriptionMedicalRecords = null;
    _streamSubscriptionAppointmentRecords?.cancel();
    _streamSubscriptionAppointmentRecords = null;
  }

  void onDisposeMedical() {
    _streamSubscriptionMedicalRecords?.cancel();
    _streamSubscriptionMedicalRecords = null;
  }

  //Appointments
  AppointmentModal setAppointment = AppointmentModal();
  List<AppointmentModal> getAppointmentList = [];

  Future addAppointment() async {
    print("${setAppointment.toJson()}");
    print("in at appointment add");
    await FBCollections.appointments.doc().set(setAppointment.toJson());
    stopLoader();
    notifyListeners();
  }

  Future<void> getAppointments() async {
    //${Provider.of<AuthProvider>(Get.context!, listen: false).appUser.phone}
    var value = await AppointmentServices.appointmentList();
    if (_streamSubscriptionAppointmentRecords == null) {
      _streamSubscriptionAppointmentRecords = value.listen((event) {
        getAppointmentList = event;
        print("length of Appointment of doctor ${getAppointmentList.length}");
      });
    }
    notifyListeners();
  }

  Future<DoctorInfo> getDoctorInfo(String doctorId) async {
    print("$doctorId");
    print("get single patient info");
    DocumentSnapshot data = await FBCollections.doctorsInfo.doc(doctorId).get();
    print("data is ${data.data()}");
    DoctorInfo info = DoctorInfo.fromJson(data.data());
    return info;
  }

  Future getSinglePatientInfo(String patientId) async {
    print("$patientId");
    print("get single patient info");
    DocumentSnapshot data = await FBCollections.users.doc(patientId).get();
    print("data is ${data.data()}");
    return data;
  }

  Future<bool> checkAppointmentForBool(
      {required String patientId, required String docID}) async {
    bool check = getAppointmentList
        .where((element) =>
            element.patientID == patientId && element.doctorId == docID)
        .toList()
        .isNotEmpty;

    print(check);
    return check;
  }

  /////////////////////////////////////////////Review////////////////////////////////////////////

  Future addReview({required Rating setRating}) async {
    print("in add review");
    await FBCollections.ratings.doc().set(setRating.toJson());
    stopLoader();

    behaviourRating = 0.0;
    checkupRating = 0.0;
    facilityRating = 0.0;

    notifyListeners();
  }

  onSubmit() async {
    try {
      // Set initial transaction ID
      setAppointment.trxId = "TempID";

      // Concurrently add appointment and set transaction
      await Future.wait([
        addAppointment(),
        setPaymentInfo(),
      ]);

      // Show success message
      ShowMessage.showToast(msg: "Appointment has been created successfully");

      // Navigate to PaymentConfirm screen
      Get.to(PaymentConfirm(
        doctorName: setAppointment.tmpDocName ?? "",
        date: setAppointment.appointmentDate?.toDate() ?? DateTime.now(),
        isVideo: setAppointment.appointmentType ==
            Enums.appointmentType.videoConsultation,
      ));
    } catch (e) {
      print("Error during appointment submission: $e");
    }
  }

// Function to set transaction in Firestore
  Future<void> setPaymentInfo() async {
    // Create TransactionsModel instance
    TransactionsModel trx = TransactionsModel(
      trxId: setAppointment.trxId,
      amount: "100",
      paidBy: AppUser.user?.phone,
      appointmentType: setAppointment.appointmentType,
      paidTo: setAppointment.doctorId,
      createdAt: Timestamp.now(),
    );

    String docId = DateTime.now().microsecondsSinceEpoch.toString();
    await FBCollections.transactions.doc(docId).set(trx.toJson());
  }
}
