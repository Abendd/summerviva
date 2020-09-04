import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'helper.dart';
import './relatedWidget.dart';
import 'package:share/share.dart';
import 'package:flutter_html/style.dart';
import 'package:flushbar/flushbar.dart';

class DetailsPage extends StatefulWidget {
  final post;
  final showRelated;
  final relatedList;

  DetailsPage({this.post, this.showRelated, this.relatedList});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isbookmarked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check();
  }

  check() {
    readcontent('favourites').then((data) {
      var d = [];
      for (int i = 0; i < data['data'].length; i++) {
        if (data['data'][i]['id'] == widget.post['id']) {
          setState(() {
            isbookmarked = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.black),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
               isbookmarked?   Icons.bookmark : Icons.bookmark_border,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    readcontent('favourites').then((data) {
                      bool flag = false;
                      for (int i = 0; i < data['data'].length; i++) {
                        if (data['data'][i]['id'] == widget.post['id']) {
                          flag = true;
                        }
                      }
                      if (!flag) {
                        data['data'].add(widget.post);
                        writeContent('favourites', data);
                        Flushbar(
                          message: "Bookmarked",

                          duration: Duration(milliseconds: 1300),
                          //   leftBarIndicatorColor: Colors.blue[300],
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                        )..show(context);

                        setState(() {
                          isbookmarked= true;
                        });
                      } else {
                        readcontent('favourites').then((data) {
                          var d = [];
                          for (int i = 0; i < data['data'].length; i++) {
                            if (data['data'][i]['id'] != widget.post['id']) {
                              d.add(data['data'][i]);
                            }
                          }
                          writeContent('favourites', {'data': d});
                        });

                        Flushbar(
                          message: "Removed",

                          duration: Duration(milliseconds: 1300),
                          //   leftBarIndicatorColor: Colors.blue[300],
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                        )..show(context);

                          setState(() {
                          isbookmarked= false;
                        });
                      }
                    });
                  }),
              IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Share.share(widget.post["link"]);
                  }),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: Stack(children: [
                    
               
                getPostImage(widget.post, w, h) != null
                    ? getPostImage(widget.post, w, h)
                    : SizedBox(),
                SizedBox(
                  height: h / 60,
                ),
  Container(
    padding: EdgeInsets.all(w/35),
    
     decoration: BoxDecoration(
         boxShadow: [BoxShadow(
      color: Colors.black,
      blurRadius: 15.0,
    ),],
        color: Colors.white,
       borderRadius: BorderRadius.circular(10)),
     margin: EdgeInsets.only(top: h / 3,left: w/45,right: w/45),
    child: Column(
      children: [

    
                  Container(
                    
                   // margin: EdgeInsets.only(left: w / 25),
                    child: Text(
                      widget.post['title']['rendered'].toString(),
                      style: TextStyle(
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: ' '),
                    ),
                  ),
                  SizedBox(height: h / 30),
                  Container(
                    //margin: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            dateConvertor(widget.post['date']),
                            style: TextStyle(
                                letterSpacing: 0, fontFamily: ' '),
                          ),
                        ),
                        FutureBuilder(
                          future: getPostAuthor(widget.post),
                          builder: (BuildContext context, var snapshot) {
                            if (snapshot.data == null) {
                              return Text('');
                            } else {
                              return Text(
                                snapshot.data,
                                style: TextStyle(
                                    letterSpacing: 0,
                                    color: Colors.black,
                                    fontFamily: ' '),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Html(
                    data: widget.post['content']['rendered'],
                    onLinkTap: (String url) {
                      launchUrl(url);
                    },
                    style: {
                      "body": Style(
                          color: Colors.grey[700],
                          fontSize: FontSize(16.0),
                          fontFamily: ' '),
                    },
                  ),
                    ],
    ),
  )
                  ],),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left:w/20,top: w/15),
                      child: Text("Related Articles",style: TextStyle(
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontFamily: ' '))),
                  ],
                ),
                widget.showRelated
                    ? RelatedArticles(
                        id: widget.post['id'],
                        relatedList: widget.relatedList,
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
