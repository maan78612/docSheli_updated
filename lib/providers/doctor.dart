import 'dart:async';
import 'dart:io';

import 'package:docsheli/Services/doctor/doctor_services.dart';
import 'package:docsheli/modal/doctor_info.dart';
import 'package:docsheli/modal/specialityModal.dart';
import 'package:docsheli/ui/shared/phone_number.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DoctorProvider extends ChangeNotifier {
  DoctorServices _doctorServices = DoctorServices();
  bool isLoading = false;
  List<DoctorInfo> allDoctors = [];
  StreamSubscription? _allDocStream;

  String? selectedCategoryID; // doctor speciality category id
  int selectedRadioTile = 0; // doctor speciality category index
  onInit() {
    getAllDoctors();
  }

  ///////////////////////////////////////////////////////////////////////////
  ///////////////////////////// OnBoarding Provider///////////////////////////////
  ///////////////////////////////////////////////////////////////////////////
  int onBoardBottomIndex = 1;

  void getAllDoctors() async {
    startLoader();
    var value = await _doctorServices.fetchAllDoctors();
    if (_allDocStream == null) {
      _allDocStream = value.listen((event) {
        allDoctors = event;
        print("doctoes = ${allDoctors.length}");
      });
    }
    stopLoader();
  }

// fetch speciality
  Future<SpecialityModal?> getSpecialityById(String id) async {
    return await _doctorServices.specialityById(id);
  }

  void calculateDocAvailability(List<String> days) {}

  // jump to next onBoarding screen
  onBoardingJumpToPageFunc(PageController controller) {
    controller.animateToPage(onBoardBottomIndex++,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    if (onBoardBottomIndex > 3) Get.offAll(() => PhoneNumberScreen());
    notifyListeners();
  }

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////Doctor SignUP Provider///////////////////////////
  //////////////////////////////////////////////////////////////////////////

  DateTime selectedDateOfBirth = DateTime.now();
  DateTime selectedDate = DateTime.now();
  int genderSelected = 0;
  int? morningTimeSelected;
  int? eveningTimeSelected;
  List<String> morningTimes = [];
  List<String> eveningTimes = [];
  File? userImage;
  final picker = ImagePicker();

  // get image function
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) userImage = File(pickedFile.path);
    notifyListeners();
  }

  //  gender selected function
  genderSelectedFunc(int index) {
    genderSelected = index;
    notifyListeners();
  }

  // selected date of birth function
  Future<Null> selectDateOfBirthFunction(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2004),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1920),
        lastDate: DateTime(2004));
    if (picked != null) selectedDateOfBirth = picked;
    controller.text = DateFormat('dd / MM / yyyy').format(selectedDateOfBirth);
    notifyListeners();
  }

  // get time slots morning
  getMorningTimeSlots(BuildContext context, TimeOfDay startTime,
      TimeOfDay endTime, Duration duration) {
    morningTimes = getTimes(startTime, endTime, duration)
        .map((tod) => tod.format(context))
        .toList();
  }

  // get time slots evening
  getEveningTimeSlots(BuildContext context, TimeOfDay startTime,
      TimeOfDay endTime, Duration duration) {
    eveningTimes = getTimes(startTime, endTime, duration)
        .map((tod) => tod.format(context))
        .toList();
  }

  String? appointmentTime;

  //  morning time selected function
  morningTimeSelectedFunc(int index) {
    morningTimeSelected = index;
    eveningTimeSelected = null;
    // appointmentTime = morningTimes[index];

    notifyListeners();
  }

  //  evening time selected function
  eveningTimeSelectedFunc(int index) {
    eveningTimeSelected = index;
    morningTimeSelected = null;

    appointmentTime = eveningTimes[index];

    notifyListeners();
  }

  // main time iteration function
  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  void startLoader() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoader() {
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _allDocStream?.cancel();
    super.dispose();
  }
}
