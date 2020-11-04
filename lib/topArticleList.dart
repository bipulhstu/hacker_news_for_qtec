import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hacker_news_for_qtec/story.dart';
import 'package:hacker_news_for_qtec/webservice.dart';
import 'commentListPage.dart';

class TopArticleList extends StatefulWidget {
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
    final url = this._stories[index].url;
    final responses = await Webservice().getCommentsByStory(story);
    final comments = responses.map((response) {
      final json = jsonDecode(response.body);
      return Comment.fromJSON(json);
    }).toList();

    debugPrint("$comments");

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => CommentListPage(story: story, comments: comments)
    )); 


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Hacker News"), 
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: _stories.length, 
        itemBuilder: (_, index) {
          return ListTile(
            onTap: () {
              _navigateToShowCommentsPage(context, index);
            },

            leading: Container(
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                alignment: Alignment.center,
                width: 50,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    children: <Widget>[
                      Text("${index+1}",style: TextStyle(color: Colors.black, fontSize: 16)),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text("${_stories[index].points}p",style: TextStyle(color: Colors.white)),
                    ],
                  ),
                )
            ),


            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_stories[index].title, style: TextStyle(fontSize: 18), textAlign: TextAlign.left),
                SizedBox(
                  height: 3.0,
                ),
                Text(_stories[index].url.substring(8, 17), style: TextStyle(fontSize: 12), textAlign: TextAlign.left,),SizedBox(
                  height: 3.0,
                ),
                Row(
                  children: <Widget>[
                    Text("${_stories[index].time}h - ", style: TextStyle(fontSize: 14), textAlign: TextAlign.left,),
                    SizedBox(
                      width: 1.0,
                    ),
                    Text(_stories[index].by, style: TextStyle(fontSize: 14), textAlign: TextAlign.left,),
                    SizedBox(
                      width: 35.0,
                    ),
                    Icon(Icons.message, color: Colors.red,),
                    SizedBox(
                      width: 1.0,
                    ),
                    Text("${_stories[index].descendants}", style: TextStyle(fontSize: 16, color: Colors.red), textAlign: TextAlign.end,),
                  ],
                )
              ],
            ),

          );
        },
      )
    );
    
  }

}