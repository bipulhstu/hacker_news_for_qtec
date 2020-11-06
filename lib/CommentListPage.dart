import 'dart:async';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:hacker_news_for_qtec/story.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommentListPage extends StatefulWidget {
  final List<Comment> comments;
  final Story story;

  CommentListPage({Key key, this.story, this.comments}) : super(key: key);

  @override
  _CommentListPageState createState() => _CommentListPageState(story, comments);
}

class _CommentListPageState extends State<CommentListPage> with AutomaticKeepAliveClientMixin<CommentListPage>{
  final List<Comment> comments;
  final Story story;

  _CommentListPageState(this.story, this.comments);

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  num position = 1;

  final key = UniqueKey();

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "${this.comments.length} Comments",
              ),
              Tab(text: "Websites"),
            ],
          ),
          title: Text(this.story.title),
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
                      child: Html(
                        data: this.comments[index].text,
                      ),
                      //style: TextStyle(fontSize: 14, color: Colors.white), textAlign: TextAlign.justify,),
                    ));
              },
            )),
            IndexedStack(
              children: <Widget>[
                WebView(
                  initialUrl: this.story.url,
                  key: key,
                  onPageStarted: startLoading,
                  onPageFinished: doneLoading,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
                Container(
                  color: Colors.red,
                  child: Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;

}
