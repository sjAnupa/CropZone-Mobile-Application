import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn(
    String phone,
    BuildContext context,
    TextEditingController smsController,
    Function changeState,
    Function changeShowLoading,
  ) async {
    try {
      changeShowLoading(true);
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          changeShowLoading(false);
        },
        verificationFailed: (FirebaseAuthException exception) {
          changeShowLoading(false);
          final snackBar = SnackBar(
            duration: Duration(seconds: 10),
            content: Text(exception.message.toString()),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          print("There is an error ${exception.message}");
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          changeState(verificationId);
        },
        codeAutoRetrievalTimeout: (value) {},
      );
    } catch (e) {
      Text("THIS IS THE ERROR $e");
    }
  }

  Future<void> signUp(UserData user) async {
    String userId = _auth.currentUser!.uid;

    user.uid = userId;

    Map<String, dynamic> form = {
      "userData": user.toMap(),
    };

    try {
      final userField =
          FirebaseFirestore.instance.collection("users").doc(userId);

      await userField.set(form);
    } catch (e) {
      Text("THIS IS THE ERROR $e");
    }
  }

  Future<void> sendCodeAgain(
    String phone,
    BuildContext context,
    TextEditingController smsController,
  ) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException exception) {
          final snackBar = SnackBar(
            duration: Duration(seconds: 10),
            content: Text(exception.message.toString()),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          print("There is an error ${exception.message}");
        },
        codeSent: (String verificationId, int? forceResendingToken) {},
        codeAutoRetrievalTimeout: (value) {},
      );
    } catch (e) {
      Text("THIS IS THE ERROR $e");
    }
  }

  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  void updateToken() async {
    String userId = _auth.currentUser!.uid;
    String? token = await fcm.getToken();
    final userField =
        FirebaseFirestore.instance.collection("users").doc(userId);
    Map<String, dynamic> userData = {
      "userData.token": token,
    };
    await userField.update(userData);
  }
}
