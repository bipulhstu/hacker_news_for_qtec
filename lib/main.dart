import 'package:flutter/material.dart';
import 'package:hacker_news_for_qtec/topArticleList.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
      home: new TopArticleList(title: 'Hacker News'),
    );
  }
}
