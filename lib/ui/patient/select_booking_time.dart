import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/modal/doctor_info.dart';
import 'package:docsheli/modal/specialityModal.dart';
import 'package:docsheli/modal/user_data.dart';
import 'package:docsheli/providers/doctor.dart';
import 'package:docsheli/providers/patient.dart';
import 'package:docsheli/utils/app_utils.dart';
import 'package:docsheli/utils/show_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class SelectBookingTime extends StatefulWidget {
  final DoctorInfo? doc;
  final SpecialityModal? sp;
  final UserData? doctorInfo;

  SelectBookingTime(
      {required this.sp, required this.doc, required this.doctorInfo});

  @override
  _SelectBookingTimeState createState() => _SelectBookingTimeState();
}

class _SelectBookingTimeState extends State<SelectBookingTime> {
  UserData? doctorUser;
  DoctorInfo? doctor;
  SpecialityModal? sp;

  DateTime now = DateTime.now();
  String? selectedTimeSlot;

  List<DateTime> availableDays = []; //calculate according to doc availability
  getAvailableDays() {
    List<int> intDays = [];
    doctor?.availableDays?.forEach((element) {
      var intDay = AppUtils.getWeekDayByStringDay(element);
      intDays.add(intDay);
    });

    for (int i = DateTime.now().day;
        i <= DateTime.now().add(Duration(days: 29)).day;
        i++) {
      print(i);
      // print(DateTime(2021, DateTime.now().month + i, intDays.first));
    }
  }

  @override
  void didChangeDependencies() {
    Provider.of<DoctorProvider>(context, listen: false).getMorningTimeSlots(
        context,
        TimeOfDay(hour: 8, minute: 30),
        TimeOfDay(hour: 11, minute: 0),
        Duration(minutes: 30));

    Provider.of<DoctorProvider>(context, listen: false).getEveningTimeSlots(
        context,
        TimeOfDay(hour: 17, minute: 30),
        TimeOfDay(hour: 20, minute: 0),
        Duration(minutes: 30));
    super.didChangeDependencies();
  }

  @override
  void initState() {
    doctorUser = widget.doctorInfo;
    doctor = widget.doc;
    sp = widget.sp;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getAvailableDays();
    return Consumer2<DoctorProvider, PatientProvider>(
        builder: (context, model, p, _) {
      bool noImage = widget.doctorInfo?.imageUrl == null ||
          (doctorUser?.imageUrl ?? "").isEmpty;
      return Scaffold(
        backgroundColor: AppConfig.colors.backGround,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppConfig.colors.themeColor.withOpacity(0.35),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width,
                    decoration: new BoxDecoration(
                        color: AppConfig.colors.themeColor.withOpacity(0.35),
                        borderRadius: new BorderRadius.only(
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: Get.height * .05),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProfileAvatar(
                              noImage
                                  ? AppUtils.userAvatar
                                  : doctorUser!.imageUrl!,
                              borderWidth: 1,
                              radius: Get.width * 0.12,
                              borderColor: AppConfig.colors.themeColor,
                            ),
                            SizedBox(width: Get.width * .04),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dr. ${doctorUser?.name ?? "-"}',
                                  style: GoogleFonts.roboto(
                                    fontSize: 20.0,
                                    color: const Color(0xFF19769F),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: Get.height * 0.005),
                                Text(
                                  "${sp?.speciality ?? ""}",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.0,
                                    color: const Color(0xFF51565F),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: Get.height * 0.007),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 0),
                                  child: SmoothStarRating(
                                      rating: 4,
                                      allowHalfRating: false,
                                      onRatingChanged: (v) {},
                                      starCount: 5,
                                      size: 18.0,
                                      filledIconData: Icons.star,
                                      halfFilledIconData: Icons.star_half,
                                      defaultIconData: Icons.star_border,
                                      color: Color(0xFFE6C010),
                                      borderColor: Color(0xFFE6C010),
                                      spacing: 1.0),
                                ),
                                SizedBox(height: Get.height * 0.02),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: Get.height * .05),
                      ],
                    ),
                  ),
                  _timeSlotsMainCard(model, p),
                  SizedBox(height: Get.height * 0.05),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        if (model.morningTimeSelected == null) {
                          return ShowMessage.showToast(
                              msg: "Please choose a time slot", isError: true);
                        }

                        p.setAppointment.appointmentDate =
                            Timestamp.fromDate(model.selectedDate);
                        p.setAppointment.timeSlot = selectedTimeSlot;
                        p.setAppointment.createdAt = Timestamp.now();
                        p.setAppointment.doctorId = doctorUser!.phone!;
                        p.setAppointment.tmpDocName = doctorUser!.name!;
                        print(p.setAppointment.toJson());
                        p.onSubmit();
                      },
                      child: Container(
                        width: Get.width * 0.9,
                        height: Get.height * 0.065,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: const Color(0xFF2A2AC0),
                        ),
                        child: Center(
                          child: Text(
                            'Make An Appointment',
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
                  ),
                  SizedBox(height: Get.height * 0.02),
                ]),
          ),
        ),
      );
    });
  }

  Widget _morningTimeSlotButton(
      DoctorProvider model, PatientProvider p, int index, String title) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 3,
                    color: Colors.black.withOpacity(.06))
              ],
              color: model.morningTimeSelected == index
                  ? AppConfig.colors.themeColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(5)),
          height: 35,
          width: 100,
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  color: model.morningTimeSelected == index
                      ? Colors.white
                      : Colors.black,
                  size: 15,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: AppConfig.textStyle.poppins().copyWith(
                      color: model.morningTimeSelected == index
                          ? Colors.white
                          : Colors.black,
                      fontSize: 13),
                ),
              ],
            ),
            onPressed: () {
              selectedTimeSlot = title;
              DateTime d = model.selectedDate;
              List<String> times = selectedTimeSlot!.split(":").toList();
              int hour = int.parse(times.first);
              int minutes = int.parse(times.last.split(" ").first);
              if (selectedTimeSlot!.contains("PM")) {
                hour = hour + 12;
              }
              print("hour:$hour====minus:$minutes");
              DateTime sd = DateTime(d.year, d.month, d.day, hour, minutes);

              print(sd);
              p.setAppointment.appointmentDate = Timestamp.fromDate(sd);
              model.morningTimeSelectedFunc(index);
            },
          ),
        ));
  }

  // evening time slots button
  Widget _eveningTimeSlotButton(DoctorProvider model, int index, String title) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 3,
                    color: Colors.black.withOpacity(.06))
              ],
              color: model.eveningTimeSelected == index
                  ? AppConfig.colors.themeColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(5)),
          height: 35,
          width: 100,
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  color: model.eveningTimeSelected == index
                      ? Colors.white
                      : Colors.black,
                  size: 15,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: AppConfig.textStyle.poppins().copyWith(
                      color: model.eveningTimeSelected == index
                          ? Colors.white
                          : Colors.black,
                      fontSize: 13),
                ),
              ],
            ),
            onPressed: () {
              model.eveningTimeSelectedFunc(index);
            },
          ),
        ));
  }

  // time slots main card
  Widget _timeSlotsMainCard(DoctorProvider model, PatientProvider p) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Get.width * .05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "${DateFormat('MMMM yyyy ').format(now)}",
              style: AppConfig.textStyle.poppins().copyWith(
                  fontSize: Get.width * .05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          DatePicker(
            DateTime.now(),
            initialSelectedDate: DateTime.now(),
            selectionColor: AppConfig.colors.themeColor,
            selectedTextColor: Colors.white,
            activeDates: [
              DateTime.now(),
            ],
            onDateChange: (date) {
              setState(() {
                model.selectedDate = date;
                model.morningTimeSelected = null;
              });
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(top: 15, left: 6),
              child: Text(
                "Time Slots",
                style: AppConfig.textStyle.poppins().copyWith(
                    fontSize: Get.width * .04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
          Center(
            child: Wrap(
              children: List.generate(
                  doctor?.availableSlots.length ?? 0,
                  (index) => _morningTimeSlotButton(
                      model, p, index, doctor!.availableSlots[index])),
            ),
          ),
        ],
      ),
    );
  }
}
