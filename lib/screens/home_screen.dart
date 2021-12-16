import '../../screens/claim-status/claim_status_page.dart';
import '../../screens/form_handler.dart';
import '../../screens/messages/messages.dart';
import '../../screens/sign-in/login_screen.dart';
import '../../service/authentication.dart';
import '../../service/form_service.dart';
import '../../service/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  static const routName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  FormService formService = FormService();
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  final Authentication authentication = Authentication();

  @override
  void initState() {
    super.initState();
    formService.newFetchForm();
    authentication.updateToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification!;
      // AndroidNotification android = message.notification!.android!;

      await _showNotification(notification);
    });
  }

  Future<void> _showNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'high_importance_channel', 'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, notification.title, notification.body, platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> signOut() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("  Do you want to Log out?"),
        content: Container(
          height: 70,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
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
    ));
  }

  Future<bool> _exitApp() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("  Do you want to exit?"),
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
                          SystemNavigator.pop();
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
      onWillPop: () => _exitApp(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            // Stack(
            //   children: [
            //     IconButton(onPressed: () {}, icon: Icon(Icons.message)),
            //     Positioned(
            //       top: 5,
            //       right: 5,
            //       child: Container(
            //         height: 15,
            //         width: 15,
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           color: Colors.red[500], // inner circle color
            //         ),
            //         child: Center(
            //             child: Text(
            //           "5",
            //           style:
            //               TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            //         )),
            //       ),
            //     ),
            //   ],
            // ),
            IconButton(
                onPressed: () {
                  signOut();
                },
                icon: Icon(Icons.logout)),
          ],
          title: Text("CropZone"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 200,
                  child: ElevatedButton(
                      style: ButtonStyle(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FormHandler()));
                      },
                      child: Text("Submit New Claim")),
                ),
                SizedBox(height: 20),
                Container(
                  height: 40,
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClaimStatus()));
                      },
                      child: Text("View My Claims")),
                ),
                SizedBox(height: 20),
                Container(
                  height: 40,
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Messages()));
                      },
                      child: Text("Government Messages")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
