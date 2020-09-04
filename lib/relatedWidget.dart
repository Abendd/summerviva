import 'package:Nassau_The_Gaurdian/helper.dart';
import 'package:flutter/material.dart';

import 'detailsPage.dart';

class RelatedArticles extends StatefulWidget {
  final relatedList;
  final id;
  const RelatedArticles({Key key, this.relatedList, this.id}) : super(key: key);

  @override
  _RelatedArticlesState createState() => _RelatedArticlesState();
}

class _RelatedArticlesState extends State<RelatedArticles> {
  var finalList;
  @override
  void initState() {
    initialiseList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h / 2.5,
      margin: EdgeInsets.only(top:w/30),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: finalList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(
                    post: finalList[index],
                    showRelated: true,
                    relatedList: widget.relatedList,
                  ),
                ),
              );
            },
            child: Container(
              
                padding: EdgeInsets.only(left:w/20,right: w/20),
                child: Column(
                  children: [
                    getPostImage(finalList[index], w, h) != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                               
                                  child: Text(
                                      finalList[index]['title']['rendered'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OPTICenturyNova')),
                                  width: w / 2),
                              ClipRRect(
                                  child: Container(
                                      child:
                                          getPostImage(finalList[index], w, h),
                                      width: h / 10,
                                      height: h / 10),
                                  borderRadius: BorderRadius.circular(15))
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  child: Text(
                                      finalList[index]['title']['rendered'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OPTICenturyNova')),
                                  width: w / 1.2),
                            ],
                          ),
                    Divider(
                      color: Colors.grey[600],
                      height: h / 20,
                    )
                  ],
                )),
          );
        },
      ),
    );
  }

  initialiseList() {
    var l = [];
    for (int i = 0; i < 6; i++) {
      if (widget.relatedList[i]['id'] != widget.id) {
        l.add(widget.relatedList[i]);
      }
      if (l.length == 5) {
        break;
      }
    }
    setState(() {
      finalList = l;
    });
  }
}
