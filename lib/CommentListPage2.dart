import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hacker_news_for_qtec/story.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommentListPage extends StatelessWidget {
  final List<Comment> comments;
  final Story story;
  CommentListPage({this.story, this.comments});

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Comments",
              ),
              Tab(text: "Websites"),
            ],
          ),
          title: Text(this.story.title), backgroundColor: Colors.orange,
        ),
        body: TabBarView(
          children: [
            Center(
                child: ListView.builder(
              itemCount: this.comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                    leading: Container(
                        alignment: Alignment.center,
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text("${1 + index}",
                            style:
                                TextStyle(fontSize: 22, color: Colors.white))),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(this.comments[index].text,
                          style: TextStyle(fontSize: 18)),
                    ));
              },
            )),
            Center(child: Container(
              child: WebView(
                initialUrl: this.story.url,
                onWebViewCreated: (WebViewController webViewController){
                  _controller.complete(webViewController);
                },

              ),
            )
            ),
          ],
        ),
      ),
    );
  }
}
