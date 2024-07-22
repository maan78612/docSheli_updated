import 'package:docsheli/constants/app_constants.dart';
import 'package:docsheli/providers/auth.dart';
import 'package:docsheli/ui/shared/drawer.dart';
import 'package:docsheli/ui/shared/globals/global_variables.dart';
import 'package:docsheli/ui/sign_up/patient_signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'appointments.dart';
import 'doctors_list.dart';
import 'medical_record.dart';

class SemiDashBoard extends StatefulWidget {
  int _selectedIndex;
  SemiDashBoard(this._selectedIndex);
  @override
  _SemiDashBoardState createState() => _SemiDashBoardState(_selectedIndex);
}

class _SemiDashBoardState extends State<SemiDashBoard> {
  int _selectedIndex;
  _SemiDashBoardState(this._selectedIndex);
  var scaffoldKey1 = new GlobalKey<ScaffoldState>();
  TextEditingController searchCtrl = TextEditingController();
  String toSearch = "";
  @override
  void initState() {
    print("Selected index is :$_selectedIndex");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, model, _) {
      return Scaffold(
        key: scaffoldKey1,
        backgroundColor: AppConfig.colors.backGround,
        appBar: AppBar(
          backgroundColor: AppConfig.colors.themeColor,
          leading: GestureDetector(
            onTap: () {
              scaffoldKey1.currentState?.openDrawer();
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Image.asset(
                AppConfig.images.drawerImg,
                color: Colors.white,
                scale: 4,
              ),
            ),
          ),
          title: Center(
            child: Text(
              _selectedIndex == 0
                  ? 'docsheli'
                  : _selectedIndex == 1
                      ? "My Appointments"
                      : isDoctor
                          ? "Account Settings"
                          : "Medical Records",
              style: TextStyle(
                fontFamily: 'Bahnschrift',
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                print("profile image");
                Get.to(PatientSignUp(
                  appBarTitle: "Account Settings",
                  subTitle: "Profile",
                  isProfile: true,
                  profileData: model.appUser!,
                ));
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  AppConfig.images.profile,
                  color: Colors.white,
                  scale: 4,
                ),
              ),
            ),
          ],
        ),
        drawer: DrawerCustom(),
        body: _getPage(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(AppConfig.images.btmDocList),
                    color: _selectedIndex == 0
                        ? Colors.black
                        : AppConfig.colors.btmIcon,
                  ),
                  label: 'Home',
                  backgroundColor: Color(0xffF4F2F2)),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(AppConfig.images.btmAppointments),
                    color: _selectedIndex == 1
                        ? Colors.black
                        : AppConfig.colors.btmIcon,
                  ),
                  label: 'My Appointments',
                  backgroundColor: Color(0xffF4F2F2)),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage(isDoctor
                      ? AppConfig.images.dashProfile
                      : AppConfig.images.btmMedical),
                  color: _selectedIndex == 2
                      ? Colors.black
                      : AppConfig.colors.btmIcon,
                ),
                label: isDoctor ? "Profile" : 'Medical Records',
                backgroundColor: Color(0xffF4F2F2),
              ),
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            selectedIconTheme: IconThemeData(color: Colors.black),
            iconSize: 30,
            onTap: _onItemTapped,
            elevation: 5),
      );
    });
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return DoctorsList();
      case 1:
        return Appointments();
      case 2:
        return MedicalRecord();

      default:
        return DoctorsList();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
