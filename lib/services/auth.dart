import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docsheli/constants/firebase_collections.dart';
import 'package:docsheli/modal/doctor_info.dart';
import 'package:docsheli/modal/user_data.dart';
import 'package:docsheli/utils/show_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> verifyPhoneNumber(
      {required Function onSent, required String phoneNumber}) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await _auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (authException) {
          debugPrint(authException.message);
          ShowMessage.showToast(
            msg:
                'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}',
            isError: true,
          );
        },
        codeSent: (verificationId, [int? forceResendingToken]) {
          onSent(verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      print('Failed to Verify Phone Number: $e');
    }
  }

  Future<User?> signInWithPhoneNumber(String otp, String verificationId) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final User? user = (await _auth.signInWithCredential(credential)).user;
      return user;
    } catch (e) {
      ShowMessage.showToast(msg: e.toString(), isError: true);
      return null;
    }
  }

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserData?> getUserById(String? email) async {
    if ((email ?? "").isNotEmpty) {
      DocumentSnapshot doc = await FBCollections.users.doc(email).get();
      if (doc.exists) {
        return UserData.fromJson(doc.data());
      }
    }
    return null;
  }

  Future<DoctorInfo?> getDoctorById(String id) async {
    if (id.isNotEmpty) {
      DocumentSnapshot doc = await FBCollections.doctorsInfo.doc(id).get();
      if (doc.exists) {
        return DoctorInfo.fromJson(doc.data());
      }
    }
    return null;
  }

  Future<DoctorInfo?> getDoctorByDocRef(DocumentReference? ref) async {
    if (ref == null) {
      return null;
    }
    var query =
        await FBCollections.doctorsInfo.where("user_ref", isEqualTo: ref).get();
    if (query.docs.isEmpty) {
      return null;
    }
    DocumentSnapshot doc = query.docs.first;
    return DoctorInfo.fromJson(doc.data());
  }

  Future<void> setUserData({
    required String phoneNumber,
    required Map<String, dynamic> payload,
  }) async {
    DocumentReference dr = FBCollections.users.doc(phoneNumber);
    try {
      await dr.set(payload);
    } catch (e) {
      ShowMessage.showToast(msg: e.toString(), isError: true);
    }
  }

  Future<void> updateUserData({
    required String userEmail,
    required Map<String, dynamic> payload,
  }) async {
    DocumentReference dr = FBCollections.users.doc(userEmail);
    try {
      await dr.update(payload);
    } catch (e) {
      ShowMessage.showToast(msg: e.toString(), isError: true);
    }
  }

  Future<List<DoctorInfo>> getAllDoctors() async {
    QuerySnapshot qs = await FBCollections.doctorsInfo.get();
    return qs.docs.map((e) => DoctorInfo.fromJson(e.data())).toList();
  }
}
