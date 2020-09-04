import 'package:flutter/material.dart';

import 'favourites.dart';
import 'helper.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool showSideMenu = false;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
         centerTitle: true,
                    iconTheme: IconThemeData(color: Colors.white),
                    elevation: 0,
                    backgroundColor: Color(0xff1b98e0),
                    title: Text(
                      'The Nassau Guardian',
                      style: TextStyle(color: Colors.white, fontSize: 27, fontFamily: ' ',fontWeight: FontWeight.w900),
                    ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: h / 30),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: w / 10,
                right: w / 10,
              ),
              width: double.infinity,
              child: Text(
                'General',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Container(
            //   margin: EdgeInsets.only(
            //     left: w / 10,
            //     right: w / 10,
            //   ),
            //   height: h / 19,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       Column(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
            //           Text(
            //             'Show side menu on start',
            //             style: TextStyle(fontSize: 17),
            //           ),
            //           Text(
            //             'Yes / No',
            //             style: TextStyle(
            //                 fontSize: 15, fontWeight: FontWeight.w300),
            //           ),
            //         ],
            //       ),
            //       Checkbox(
            //         materialTapTargetSize: MaterialTapTargetSize.padded,
            //         value: showSideMenu,
            //         onChanged: (val) {
            //           setState(() {
            //             showSideMenu = val;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // Divider(
            //   thickness: 2,
            //   height: h / 20,
            //   indent: w / 20,
            //   endIndent: w / 20,
            // ),
            // Container(
            //   margin: EdgeInsets.only(
            //     left: w / 10,
            //     right: w / 10,
            //   ),
            //   width: w,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       Text(
            //         'Text Size',
            //         style: TextStyle(fontSize: 17),
            //       ),
            //       Text(
            //         'Prefered text size for aticles and posts',
            //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   margin: EdgeInsets.only(left: w / 10, right: w / 10, top: h / 95),
            //   width: double.infinity,
            //   child: Text(
            //     'Other',
            //     style: TextStyle(
            //       fontSize: 17,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(
                top: h / 30,
                left: w / 10,
                right: w / 10,
              ),
              width: w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'About',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    'Information about our application',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
              height: h / 20,
              indent: w / 20,
              endIndent: w / 20,
            ),
            Container(
              margin: EdgeInsets.only(
                left: w / 10,
                right: w / 10,
              ),
              width: w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Open-Source licenses',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    'Licence details for open-source software',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
              height: h / 20,
              indent: w / 20,
              endIndent: w / 20,
            ),
            Container(
              margin: EdgeInsets.only(
                left: w / 10,
                right: w / 10,
              ),
              width: w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Rate this app',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    'Help other users enjoy this applications',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
              height: h / 20,
              indent: w / 20,
              endIndent: w / 20,
            ),
            Container(
              margin: EdgeInsets.only(
                left: w / 10,
                right: w / 10,
              ),
              width: w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Version',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    '3',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
              height: h / 20,
              indent: w / 20,
              endIndent: w / 20,
            ),
          ],
        ),
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Settings) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Settings()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Favourites()));
    }
  }
}
