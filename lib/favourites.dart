import 'package:flutter/material.dart';
import 'detailsPage.dart';
import 'helper.dart';
import 'package:flutter_html/style.dart';
import 'package:flushbar/flushbar.dart';

import 'package:flutter_html/flutter_html.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  var data;
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return data == null
        ? Scaffold(
            body: Center(
              child: Text('laoding'),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 0,
              backgroundColor: Color(0xff1b98e0),
              title: Text(
                'The Nassau Guardian',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontFamily: ' ',
                    fontWeight: FontWeight.w900),
              ),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        data = [];
                      });
                      writeContent('favourites', {'data': []});
                         Flushbar(
                          message: "All articles deleted",
                        
                          duration: Duration(milliseconds: 1300),
                       //   leftBarIndicatorColor: Colors.blue[300],
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                        )..show(context);
                    })
              ],
            ),
            body: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var post = data[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                    post: data[index],
                                    showRelated: false,
                                  )));
                    },
                
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                              child: getPostImage(post, w, h),
                              height:
                                  getPostImage(post, w, h) != null ? h / 4 : 0,
                              width: getPostImage(post, w, h) != null
                                  ? w / 0.5
                                  : 0),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  dateConvertor(post['date']
                                      .toString()
                                      .replaceAll('T', ' ')),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: ' ',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                FutureBuilder(
                                  future: getPostAuthor(post),
                                  builder:
                                      (BuildContext context, var snapshot) {
                                    if (snapshot.data == null) {
                                      return Text('');
                                    } else {
                                      return Text(
                                        snapshot.data,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: ' ',
                                          fontWeight: FontWeight.w300,
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
                              data: post['excerpt']['rendered'].toString(),
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
                }),
          );
  }

  getData() async {
    var d = await readcontent('favourites');
    setState(() {
      data = d['data'];
    });
  }
}
