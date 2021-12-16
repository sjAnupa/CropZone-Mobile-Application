import '../../models/user.dart';
import '../../service/authentication.dart';
import '../../widgets/alerts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../home_screen.dart';

enum UserRegistrationState {
  SIGN_UP_FORM,
  OTP_FORM,
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  UserData user = UserData();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController smsController = TextEditingController();
  Authentication authentication = Authentication();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? verifyId;
  bool showLoading = false;
  UserRegistrationState currentState = UserRegistrationState.SIGN_UP_FORM;
  String? mobile;
  void changeState(String verificationId) {
    setState(() {
      showLoading = false;
      currentState = UserRegistrationState.OTP_FORM;
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
        try {
          await authentication.signUp(user);
        } catch (e) {
          print("THIS IS THE ERROR $e");
        }
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
    return showLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : currentState == UserRegistrationState.SIGN_UP_FORM
            ? Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.green.shade900,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                body: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                child: Image.asset(
                                  "assets/Cropzone.png",
                                  scale: 0.6,
                                ),
                              ),
                              SizedBox(height: 25),
                              TextFormField(
                                autofocus: false,
                                controller: nameController,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please Enter Your Name");
                                  } else if (value.length < 3) {
                                    return "Name must contains at least 3 characters";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  nameController.text = value!;
                                  user.fullName = value;
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "Full Name",
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),
                              TextFormField(
                                autofocus: false,
                                controller: nicController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  try {
                                    int.parse(value.toString().substring(0, 9));
                                  } catch (e) {
                                    return "Please Enter a valid National ID card number";
                                  }

                                  if (value!.isEmpty) {
                                    return ("Please Enter National ID card number");
                                  } else if (!(value.length > 9)) {
                                    return "Please Enter a valid National ID card number";
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  nicController.text = value!;
                                  user.nic = value;
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.card_travel_rounded),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "NIC",
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),
                              TextFormField(
                                autofocus: false,
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please Enter Email Address.");
                                  }
                                  if (!RegExp(
                                          "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                      .hasMatch(value)) {
                                    return ("Please Enter a Valid Email Address.");
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  emailController.text = value!;
                                  user.email = value;
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email_rounded),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "Email ",
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),
                              TextFormField(
                                autofocus: false,
                                controller: mobileController,
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
                                  mobileController.text = value!;
                                  user.contactNo = "+94$value";
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
                              SizedBox(height: 25),
                              Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.green.shade900,
                                child: MaterialButton(
                                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  minWidth: MediaQuery.of(context).size.width,
                                  onPressed: () async {
                                    _formKey.currentState!.validate();
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      mobile = "+94${mobileController.text}";

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
                                    "Continue",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: otpScreen(
                        context,
                        smsController,
                        verifyId.toString(),
                        signInWithCredential,
                        mobile.toString(),
                      ),
                    ),
                  ],
                ),
              );
  }
}
