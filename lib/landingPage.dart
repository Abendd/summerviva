import 'dart:convert';
import 'package:Nassau_The_Gaurdian/favourites.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import './detailsPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helper.dart';
import 'style.dart';
import 'Setting.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class LandingPage extends StatefulWidget {
  final int categoryNumber;
  final int prevCategoryNumber;
  LandingPage({Key key, this.categoryNumber, this.prevCategoryNumber})
      : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final baseUrl = 'https://thenassauguardian.com/wp-json/wp/v2/posts?';
  var posts = [];
  int postPageNumber = 1;
  var search = [];
  ScrollController _controller;
  var viewType = "normal"; //compact, immersive, normal
  bool searching = false;
  _fetchPosts(category) async {
    final response = await http.get(
        baseUrl +
            'categories=' +
            category.toString() +
            '&page=' +
            postPageNumber.toString(),
        headers: {'Accept': 'application/json'});

    var decodedResponse = jsonDecode(response.body);
    var dummy = posts + decodedResponse;
    setState(() {
      posts = dummy;
      postPageNumber += 1;
    });
  }

  _fetchSearchPosts(category, key) async {
    final response = await http.get(
        baseUrl + '&page=' + postPageNumber.toString() + '&search=' + key,
        headers: {'Accept': 'application/json'});

    var decodedResponse = jsonDecode(response.body);

    setState(() {
      search = decodedResponse;
      _isloading = false;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void openDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  //
  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _fetchPosts(widget.categoryNumber);
    initializeFavourites();
    super.initState();
  }

  Future<void> _launchInApp(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'header_key': 'header_value'},
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  final MailOptions mailOptions = MailOptions(
    body: '',
    subject: '',
    recipients: ['rishabh.davesar@example.com'],
    isHTML: true,
    bccRecipients: [''],
    ccRecipients: [''],
  );

  bool dialVisible = true;
  var _isloading = false;

  @override
  Widget build(BuildContext context) {
    //  _scaffoldKey.currentState.openDrawer();

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    if (posts.length == 0) {
      if (widget.categoryNumber == 938 && widget.prevCategoryNumber == -1) {
        return Container(
          height: h,
          child: Image.asset(
            'assets/images/splash.jpg',
            fit: BoxFit.cover,
          ),
        );
      } else {
        return Scaffold(
            key: _scaffoldKey,
            body: Center(
              child: Container(
                width: w / 5,
                height: w / 5,
                child: Stack(
                  children: [
                    Center(child: Text("")),
                    Container(
                      width: w / 5,
                      height: w / 5,
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.blue[200]),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: searching
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        searching = false;
                        search = null;
                      });
                    }),
                title: Container(
                  width: w / 1.4,
                  child: TextField(
                    onSubmitted: (val) async {
                      setState(() {
                        _isloading = true;
                      });
                      _fetchSearchPosts(widget.categoryNumber, val);
                    },
                    style: TextStyle(
                      letterSpacing: 0,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : null,
        floatingActionButton: SpeedDial(
          // both default to 16
          marginRight: 18,
          marginBottom: 20,

          animatedIcon: AnimatedIcons.view_list,
          animatedIconTheme: IconThemeData(size: 22.0),
          // this is ignored if animatedIcon is non null
          // child: Icon(Icons.add),
          visible: dialVisible,
          // If true user is forced to close dial manually
          // by tapping main button and overlay is not rendered.
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.bookmark),
              backgroundColor: Colors.black,
              labelStyle: TextStyle(letterSpacing: 0, fontSize: 18.0),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Favourites())),
            ),
            SpeedDialChild(
                child: Icon(Icons.search),
                backgroundColor: Colors.black,
                labelStyle: TextStyle(letterSpacing: 0, fontSize: 18.0),
                onTap: () {
                  setState(() {
                    searching = true;
                  });
                }),
            SpeedDialChild(
              child: Icon(Icons.settings),
              backgroundColor: Colors.black,
              labelStyle: TextStyle(letterSpacing: 0, fontSize: 18.0),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings())),
            ),
          ],
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: w,
                    child: DrawerHeader(
                      //  margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                      child: Image.asset(
                        'assets/images/drawer_header.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(w / 30),
                        child: Text(
                          'News',
                          style: drawerStyle,
                        )),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LandingPage(
                                    categoryNumber: 938,
                                    prevCategoryNumber: widget.categoryNumber,
                                  )));
                    },
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                    height: 5,
                    indent: 10,
                    endIndent: 10,
                  ),
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(w / 30),
                        child: Text(
                          'National Review',
                          style: drawerStyle,
                        )),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LandingPage(
                                    categoryNumber: 931,
                                    prevCategoryNumber: widget.categoryNumber,
                                  )));
                    },
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                    height: 5,
                    indent: 10,
                    endIndent: 10,
                  ),
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(w / 30),
                        child: Text('Perspective', style: drawerStyle)),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LandingPage(
                                    categoryNumber: 1246,
                                    prevCategoryNumber: widget.categoryNumber,
                                  )));
                    },
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                    height: 5,
                    indent: 10,
                    endIndent: 10,
                  ),
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(w / 30),
                        child: Text('Business', style: drawerStyle)),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LandingPage(
                                    categoryNumber: 2,
                                    prevCategoryNumber: widget.categoryNumber,
                                  )));
                    },
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                    height: 5,
                    indent: 10,
                    endIndent: 10,
                  ),
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(w / 30),
                        child: Text('Sports', style: drawerStyle)),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LandingPage(
                                    categoryNumber: 900,
                                    prevCategoryNumber: widget.categoryNumber,
                                  )));
                    },
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                    height: 5,
                    indent: 10,
                    endIndent: 10,
                  ),
                  GestureDetector(
                      child: Container(
                          margin: EdgeInsets.all(w / 30),
                          child: Text('Opinion', style: drawerStyle)),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LandingPage(
                                      categoryNumber: 901,
                                      prevCategoryNumber: widget.categoryNumber,
                                    )));
                      }),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                    height: 5,
                    indent: 10,
                    endIndent: 10,
                  ),
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(w / 30),
                        child: Text('Religion', style: drawerStyle)),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LandingPage(
                                    categoryNumber: 933,
                                    prevCategoryNumber: widget.categoryNumber,
                                  )));
                    },
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                    height: 5,
                    indent: 10,
                    endIndent: 10,
                  ),
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(w / 30),
                        child: Text('Lifestyles', style: drawerStyle)),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LandingPage(
                                    categoryNumber: 934,
                                    prevCategoryNumber: widget.categoryNumber,
                                  )));
                    },
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                    height: 5,
                    indent: 10,
                    endIndent: 10,
                  ),
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(w / 30),
                        child: Text(
                          'Facebook',
                          style: drawerStyle,
                        )),
                    onTap: () {
                      _launchInApp('https://www.facebook.com/NassauGuardian/');
                    },
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                    height: 5,
                    indent: 10,
                    endIndent: 10,
                  ),
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(w / 30),
                        child: Text(
                          'Twitter',
                          style: drawerStyle,
                        )),
                    onTap: () {
                      _launchInApp('https://twitter.com/GuardianNassau');
                    },
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                    height: 5,
                    indent: 10,
                    endIndent: 10,
                  ),
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(w / 30),
                        child: Text(
                          'Email',
                          style: drawerStyle,
                        )),
                    onTap: () async {
                      await FlutterMailer.send(mailOptions);
                    },
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                    height: 5,
                    indent: 10,
                    endIndent: 10,
                  ),
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(w / 30),
                        child: Text(
                          'Radio',
                          style: drawerStyle,
                        )),
                    onTap: () {
                      _launchInApp(
                          'https://radio.streamcomedia.com/station/tngr969fm/player.html');
                    },
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                    height: 5,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Divider(
                    thickness: 1,
                    height: 5,
                    indent: 10,
                    endIndent: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: searching // add loading when searching
            ? _isloading
                ? Center(
                    child: Container(
                      width: w / 5,
                      height: w / 5,
                      child: Stack(
                        children: [
                          Center(child: Text("")),
                          Container(
                            width: w / 5,
                            height: w / 5,
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.blue[200]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : search == null
                    ? Container(
                        height: h,
                        width: w,
                        child: Center(
                          child: Text(
                            "Please enter something",
                          ),
                        ),
                      )
                    : search.length == 0
                        ? Container(
                            height: h,
                            width: w,
                            child: Center(
                              child: Text("No results to show"),
                            ),
                          )
                        : ListView.builder(
                            itemCount: search.length,
                            itemBuilder: (context, index) {
                              var post = search[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailsPage(
                                                post: post,
                                                showRelated: true,
                                                relatedList: search,
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: getPostImage(post, w, h),
                                        ),
                                      ),
                                      SizedBox(
                                        height: h / 60,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: w / 40),
                                        width: w / 1.09,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          post['title']['rendered'].toString(),
                                          style: TextStyle(
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 24,
                                              fontFamily: ' '),
                                        ),
                                      ),
                                      SizedBox(
                                        height: h / 80,
                                      ),
                                      Container(
                                        width: w / 1.09,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              dateConvertor(post['date']
                                                  .toString()
                                                  .replaceAll('T', ' ')),
                                              style: TextStyle(
                                                letterSpacing: 0,
                                                fontSize: 10,
                                                fontFamily: ' ',
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            FutureBuilder(
                                              future: getPostAuthor(post),
                                              builder: (BuildContext context,
                                                  var snapshot) {
                                                if (snapshot.data == null) {
                                                  return Text('');
                                                } else {
                                                  return Text(
                                                    snapshot.data,
                                                    style: TextStyle(
                                                      letterSpacing: 0,
                                                      fontSize: 10,
                                                      fontFamily: ' ',
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: h / 80,
                                      ),
                                      Container(
                                        width: w / 1.09,
                                        child: Html(
                                          data: post['excerpt']['rendered']
                                              .toString(),
                                          style: {
                                            "body": Style(
                                              color: Colors.grey[600],
                                              fontSize: FontSize(10.0),
                                              fontFamily: ' ',
                                              fontWeight: FontWeight.w300,
                                            ),
                                          },
                                          onLinkTap: (String link) {
                                            launchUrl(link);
                                          },
                                        ),
                                      ),
                                      Container(
                                        color: Colors.white,
                                        height: h / 80,
                                      ),
                                      Container(
                                        color: Colors.grey[100],
                                        height: h / 80,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
            : RefreshIndicator(
                onRefresh: () => _fetchPosts(widget.categoryNumber),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _controller,
                  slivers: [
                    SliverAppBar(
                      centerTitle: true,
                      iconTheme: IconThemeData(color: Colors.white),
                      elevation: 0,
                      backgroundColor: Color(0xff1b98e0),
                      title: Text(
                        'The Nassau Guardian',
                        style: TextStyle(
                            letterSpacing: 0,
                            color: Colors.white,
                            fontSize: 27,
                            fontFamily: ' ',
                            fontWeight: FontWeight.w800),
                      ),
                      actions: <Widget>[],
                      floating: true,
                      pinned: false,
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var post = posts[index];
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsPage(
                                            post: post,
                                            showRelated: true,
                                            relatedList: posts,
                                          )));
                            },
                            child: index == 0 ||
                                    getPostImage(post, w, h) == null
                                ? Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: getPostImage(post, w, h),
                                          ),
                                        ),
                                        SizedBox(
                                          height: h / 60,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: w / 40),
                                          width: w / 1.09,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            post['title']['rendered']
                                                .toString(),
                                            style: TextStyle(
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 24,
                                                fontFamily: ' '),
                                          ),
                                        ),
                                        SizedBox(
                                          height: h / 80,
                                        ),
                                        Container(
                                          width: w / 1.09,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                dateConvertor(post['date']
                                                    .toString()
                                                    .replaceAll('T', ' ')),
                                                style: TextStyle(
                                                  letterSpacing: 0,
                                                  fontSize: 12,
                                                  fontFamily: ' ',
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              FutureBuilder(
                                                future: getPostAuthor(post),
                                                builder: (BuildContext context,
                                                    var snapshot) {
                                                  if (snapshot.data == null) {
                                                    return Text('');
                                                  } else {
                                                    return Text(
                                                      snapshot.data,
                                                      style: TextStyle(
                                                        letterSpacing: 0,
                                                        fontSize: 12,
                                                        fontFamily: ' ',
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: h / 80,
                                        ),
                                        Container(
                                          width: w / 1.09,
                                          child: Html(
                                            data: post['excerpt']['rendered']
                                                .toString(),
                                            style: {
                                              "body": Style(
                                                color: Colors.grey[600],
                                                fontSize: FontSize(12.0),
                                                fontFamily: ' ',
                                                fontWeight: FontWeight.w300,
                                              ),
                                            },
                                            onLinkTap: (String link) {
                                              launchUrl(link);
                                            },
                                          ),
                                        ),
                                        Container(
                                          color: Colors.white,
                                          height: h / 80,
                                        ),
                                        Container(
                                          color: Colors.grey[100],
                                          height: h / 80,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: h / 4.85,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Expanded(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                    //   borderRadius: BorderRadius.circular(20),
                                                    child: Container(
                                                      width: w / 2.7,
                                                      child: getPostImage(
                                                          post, w, h),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: w / 50),
                                                        width: w / 1.7,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          //'fhwerhfhwerferwhfehfohiohefioeirwhfiewf wejfopwejf  wejfjpew  9weufpwe wer-90fu -w f-0erw uf-0we uf0-erwf erw-0wf r-e f0-erw wopdj opew djvoper joerj gpoewerj vpieirhfpoer hghip',
                                                          post['title']
                                                                  ['rendered']
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              letterSpacing: 0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 18,
                                                              fontFamily: ' '),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: w / 1.7,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Html(
                                                          data: post['excerpt'][
                                                                      'rendered']
                                                                  .toString()
                                                                  .substring(
                                                                      0, 70) +
                                                              "...",
                                                          style: {
                                                            "body": Style(
                                                              color: Colors
                                                                  .grey[600],
                                                              fontSize:
                                                                  FontSize(
                                                                      12.0),
                                                              fontFamily: ' ',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                            ),
                                                          },
                                                          onLinkTap:
                                                              (String link) {
                                                            launchUrl(link);
                                                          },
                                                        ),
                                                      ),
                                                      Container(
                                                        width: w / 1.7,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              dateConvertor(post[
                                                                      'date']
                                                                  .toString()
                                                                  .replaceAll(
                                                                      'T',
                                                                      ' ')),
                                                              style: TextStyle(
                                                                letterSpacing:
                                                                    0,
                                                                fontSize: 12,
                                                                fontFamily: ' ',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          color: Colors.grey[100],
                                          height: h / 80,
                                        ),
                                      ],
                                    ),
                                  ));
                      },
                      childCount: posts.length,
                    )),
                  ],
                ),
              ));
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

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      _fetchPosts(widget.categoryNumber);
    }
  }

  initializeFavourites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('FirstTime') == null) {
      writeContent('favourites', {'data': []});
      prefs.setBool('FirstTime', false);
    }
  }
}
