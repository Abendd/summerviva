import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'landingPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
String notifyContent;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configOneSignal();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Nassau Gaurdian' ,
      home: LandingPage(
        categoryNumber: 938,
        prevCategoryNumber: -1,
      ),
    );
  }

  void configOneSignal()
  async {
    print(notifyContent.toString());
    await OneSignal.shared.init('560ce88a-a82d-42a7-93e3-1fa43a663c99');
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared.setNotificationReceivedHandler((notification) {
      setState(() {
        notifyContent= notification.jsonRepresentation().replaceAll('\\n', '\n');

      });
    });
  }
}
