import 'dart:io';

import '../../models/estimation.dart';
import '../../models/land_info.dart';
import '../../models/location.dart';
import '../../models/media.dart';
import '../../models/media_url.dart';
import '../../models/personal_info.dart';
import '../../screens/claim-form/estimation.dart';
import '../../screens/claim-form/personal_information.dart';
import '../../screens/claim-form/photo_upload.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'claim-form/land_information.dart';

class YearMonth {
  String? month;
  String? year;
  YearMonth();
}

class ImagePicked {
  bool? takePhoto1 = false;
  bool? takePhoto2 = false;
  bool? takePhoto3 = false;
  bool? takePhoto4 = false;
  bool? takePhoto5 = false;
  bool? takePhoto6 = false;
  bool? isImagePicked = false;
  ImagePicked();
}

Uuid _uuid = Uuid();

String formId = _uuid.v1();

class FormHandler extends StatefulWidget {
  const FormHandler({Key? key}) : super(key: key);

  @override
  _FormHandlerState createState() => _FormHandlerState();
}

class _FormHandlerState extends State<FormHandler>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  File? photoOfNIC;
  File? photoOfDeed;
  Media media = Media();
  PersonalInfo personalInfo = PersonalInfo();
  Estimation estimation = Estimation();
  LandInfo landInfo = LandInfo();
  YearMonth yearMonth = YearMonth();
  ImagePicked imagePicked = ImagePicked();
  MediaUrl mediaUrl = MediaUrl();
  LocationModel location = LocationModel();

  int currentPage = 0;
  void increasePageNumber(int number) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        currentPage = number;
      });
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("   Do you want to leave?"),
            content: Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text("Yes")),
                  ),
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("No")),
                  ),
                ],
              ),
            ),
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("New Claim Form"),
        ),
        body: PageView(
          controller: _pageController,
          children: [
            Column(
              children: [
                NotificationListener(
                  onNotification: (overscroll) {
                    if (overscroll is OverscrollNotification &&
                        overscroll.overscroll != 0 &&
                        overscroll.dragDetails != null) {
                      _pageController.animateToPage(
                          overscroll.overscroll < 0 ? 0 : 2,
                          curve: Curves.ease,
                          duration: Duration(milliseconds: 250));
                    }
                    return true;
                  },
                  child: Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        PersonalInformation(
                          personalInfo: personalInfo,
                          media: media,
                          increasePageNumber: increasePageNumber,
                        ),
                        LandInformation(
                          landInformation: landInfo,
                          media: media,
                          increasePageNumber: increasePageNumber,
                        ),
                        EstimationPage(
                          estimation: estimation,
                          yearMonth: yearMonth,
                          increasePageNumber: increasePageNumber,
                        ),
                        PhotoUpload(
                          formKey: _formKey,
                          media: media,
                          imagePicked: imagePicked,
                          increasePageNumber: increasePageNumber,
                          estimation: estimation,
                          personalInfo: personalInfo,
                          location: location,
                          landInfo: landInfo,
                          mediaUrl: mediaUrl,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: currentPage != 0
                          ? TextButton(
                              onPressed: () {
                                if (currentPage == 1) {
                                  _tabController.animateTo(0,
                                      curve: Curves.ease,
                                      duration: Duration(milliseconds: 250));
                                } else if (currentPage == 2) {
                                  _tabController.animateTo(1,
                                      curve: Curves.ease,
                                      duration: Duration(milliseconds: 250));
                                } else if (currentPage == 3) {
                                  _tabController.animateTo(2,
                                      curve: Curves.ease,
                                      duration: Duration(milliseconds: 250));
                                }
                              },
                              child: Text("Back"))
                          : Text(""),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: TabPageSelector(
                          controller: _tabController,
                          selectedColor: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: currentPage != 3
                          ? TextButton(
                              onPressed: () {
                                if (currentPage == 0) {
                                  _tabController.animateTo(1);
                                } else if (currentPage == 1) {
                                  _tabController.animateTo(2);
                                } else if (currentPage == 2) {
                                  _tabController.animateTo(3);
                                }
                              },
                              child: Text("Next"),
                            )
                          : Text(""),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
