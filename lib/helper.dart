import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

String dateConvertor(String rawDate) {
  Map<String, String> mapMonth = {
    '01': 'January',
    '02': 'Feburary',
    '03': 'March',
    '04': 'April',
    '05': 'May',
    '06': 'June',
    '07': 'July',
    '08': 'August',
    '09': 'September',
    '10': 'October',
    '11': 'November',
    '12': 'December'
  };

  Map<String, String> dateSuper = {
    '1': 'st',
    '2': 'nd',
    '3': 'rd',
    '4': 'th',
    '5': 'th',
    '6': 'th',
    '7': 'th',
    '8': 'th',
    '9': 'th',
    '0': 'th',
  };

  String year = rawDate.substring(0, 4);
  String month = mapMonth[rawDate.substring(5, 7)];
  String day = rawDate.substring(8, 10);
  String dayth = dateSuper[rawDate[9]];
  if (year == DateTime.now().year.toString()) {
    return day + dayth + " " + month;
  }
  return day + dayth + " " + month + " " + year;
}

class Constants {
  static const String Settings = 'Settings';
  static const String SignOut = 'Favourites';

  static const List<String> choices = <String>[Settings, SignOut];
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  // For your reference print the AppDoc directory
  print(directory.path);
  return directory.path;
}

Future<File> localFile(String filename) async {
  final path = await _localPath;
  return File('$path/' + filename);
}

writeContent(filename, content) async {
  final file = await localFile(filename + '.json');
  // Write the file
  file.writeAsStringSync(json.encode(content));
}

readcontent(filename) async {
  final file = await localFile(filename + '.json');

  // Read the file
  var val = await file.readAsString();
  Map<String, dynamic> a = json.decode(val);
  return a;
}

getPostImage(var post, double w, double h) {
  if (post['episode_featured_image'] != false &&
      post['episode_featured_image'] != null) {
    return Image.network(
      post['episode_featured_image'],
      fit: BoxFit.cover,
    );
  } else if (post['episode_featured_image'] == false ||
      post['episode_featured_image'] == null) {
    return null;
  } else {
    return Container(
      width: w / 5,
      height: w / 5,
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[200]),
      ),
    );
  }
}

launchUrl(String link) async {
  if (await canLaunch(link)) {
    await launch(link);
  } else {
    throw 'Cannot launch $link';
  }
}

getPostAuthor(post) async {
  final authorResponse = await http.get(post['_links']['author'][0]['href']);
  var authorName = jsonDecode(authorResponse.body)['name'];

  return authorName;
}
