import '../../service/authentication.dart';
import '../../widgets/alerts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../screens/sign-up/registration_screen.dart';

import '../home_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  static const routeName = '/';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();
  String? mobileNumber;

  final smsController = new TextEditingController();
  final phoneController = new TextEditingController();
  Authentication authentication = Authentication();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  String? verifyId;
  bool showLoading = false;
  String? mobile;
  void changeState(String verificationId) {
    setState(() {
      showLoading = false;
      currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
      verifyId = verificationId;
    });
  }

  void changeShowLoading(bool val) {
    setState(() {
      showLoading = val;
    });
  }

  void signInWithCredential(PhoneAuthCredential credential) async {
    changeShowLoading(true);

    try {
      final authCredential = await _auth.signInWithCredential(credential);
      if (authCredential.user != null) {
        changeShowLoading(false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      changeShowLoading(false);

      final snackBar = SnackBar(
        duration: Duration(seconds: 10),
        content: Text(e.message.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: showLoading
              ? CircularProgressIndicator()
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.white,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 300,
                              child: Image.asset(
                                "assets/Cropzone.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                            TextFormField(
                              controller: phoneController,
                              autofocus: false,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("Please Enter Mobile Number");
                                } else if (value.length != 9)
                                  return 'Mobile Number must be of 9 digit (without "0")';
                                else
                                  return null;
                              },
                              onSaved: (value) {
                                mobileNumber = value;
                              },
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    "(+94)",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 15,
                                ),
                                hintText: "Enter your Phone Number",
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.green.shade900,
                              child: MaterialButton(
                                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                minWidth: MediaQuery.of(context).size.width,
                                onPressed: () async {
                                  _formKey.currentState?.validate();
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState?.save();
                                    mobile = "+94${phoneController.text}";
                                    await authentication.signIn(
                                      mobile.toString(),
                                      context,
                                      smsController,
                                      changeState,
                                      changeShowLoading,
                                    );
                                  }
                                },
                                child: Text(
                                  "Login",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(fontSize: 20),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrationScreen()));
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.green.shade900,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : otpScreen(
                      context,
                      smsController,
                      verifyId.toString(),
                      signInWithCredential,
                      mobile.toString(),
                    ),
        ),
      ),
    );
  }
}
