import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hacker_news_for_qtec/story.dart';
import 'package:hacker_news_for_qtec/webservice.dart';
import 'CommentListPage.dart';

class TopArticleList extends StatefulWidget {
  TopArticleList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TopArticleListState createState() => _TopArticleListState();
}

class _TopArticleListState extends State<TopArticleList> {
  List<Story> _stories = List<Story>();

  @override
  void initState() {
    super.initState();
    _populateTopStories();
  }

  void _populateTopStories() async {
    final responses = await Webservice().getTopStories();
    final stories = responses.map((response) {
      final json = jsonDecode(response.body);
      return Story.fromJSON(json);
    }).toList();

    setState(() {
      _stories = stories;
    });
  }

  void _navigateToShowCommentsPage(BuildContext context, int index) async {
    final story = this._stories[index];
    final responses = await Webservice().getCommentsByStory(story);
    final comments = responses.map((response) {
      final json = jsonDecode(response.body);
      return Comment.fromJSON(json);
    }).toList();

    debugPrint("$comments");

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CommentListPage(story: story, comments: comments)));
  }

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text(widget.title),
    );

    final makeBottom = Container(
      height: 55.0,
      child: BottomAppBar(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.blur_on, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.hotel, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.account_box, color: Colors.white),
              onPressed: () {},
            )
          ],
        ),
      ),
    );

    final makeBody = Container(
        child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _stories.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                  onTap: () {
                    _navigateToShowCommentsPage(context, index);
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  leading: Container(
                      child: new Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      children: <Widget>[
                        Text("${index + 1}",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text("${_stories[index].points}p",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  )),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_stories[index].title,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.left),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        _stories[index].url.substring(8),
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "${_stories[index].time}h - ",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            width: 1.0,
                          ),
                          Text(
                            _stories[index].by,
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      )
                    ],
                  ),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                  trailing: Column(
                    children: <Widget>[
                      Icon(
                        Icons.message,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 1.0,
                      ),
                      Text(
                        "${_stories[index].commentIds.length}",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  )),
            ));
      },
    ));

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: makeBody,
      bottomNavigationBar: makeBottom,

    );
  }

}
