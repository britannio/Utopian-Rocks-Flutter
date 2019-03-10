import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share/share.dart';

import 'package:utopian_rocks_2/models/contribution_model.dart';
import 'package:utopian_rocks_2/utils.dart';

class ContributionDetailPage extends StatefulWidget {
  final Contribution contribution;

  ContributionDetailPage({Key key, @required this.contribution})
      : super(key: key);

  @override
  _ContributionDetailPageState createState() => _ContributionDetailPageState();
}

class _ContributionDetailPageState extends State<ContributionDetailPage> {
  WebViewController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool controllerReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('${widget.contribution.author}'),
        /*  · ${widget.contribution.totalVotes} votes'), */
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (controllerReady) {
                _controller.canGoBack().then(
                  (canGoBack) {
                    if (canGoBack) _controller.goBack();
                  },
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              if (controllerReady) {
                _controller.canGoForward().then(
                  (canGoForward) {
                    if (canGoForward) _controller.goForward();
                  },
                );
              }
            },
          ),
          PopupMenuButton<WebViewOptions>(
            tooltip: 'Options',
            icon: Icon(Icons.more_vert),
            onSelected: (WebViewOptions option) {
              switch (option) {
                case WebViewOptions.COPY_URL:
                  Clipboard.setData(
                          ClipboardData(text: widget.contribution.url))
                      .then(
                    (_) {
                      _scaffoldKey.currentState.showSnackBar(
                        (SnackBar(
                          content: Text('Copied to Clipboard'),
                        )),
                      );
                    },
                  );

                  break;
                case WebViewOptions.OPEN_EXTERNALLY:
                  if (controllerReady)
                    _controller.currentUrl().then((currentUrl) => launchUrl);
                  break;
                case WebViewOptions.RELOAD:
                  if (controllerReady) _controller.reload();
                  break;
                case WebViewOptions.SHARE_URL:
                  Share.share(widget.contribution.url);
                  break;
                case WebViewOptions.VIEW_REPOSITORY:
                  if (controllerReady)
                    _controller.loadUrl(widget.contribution.repositoryUrl);
                  break;
              }
            },
            itemBuilder: (context) {
              return <PopupMenuItem<WebViewOptions>>[
                PopupMenuItem<WebViewOptions>(
                  value: WebViewOptions.RELOAD,
                  child: Text('Refresh'),
                ),
                PopupMenuItem<WebViewOptions>(
                  value: WebViewOptions.OPEN_EXTERNALLY,
                  child: Text('Open in browser'),
                ),
                PopupMenuItem<WebViewOptions>(
                  value: WebViewOptions.COPY_URL,
                  child: Text('Copy url'),
                ),
                PopupMenuItem<WebViewOptions>(
                  value: WebViewOptions.SHARE_URL,
                  child: Text('Share page'),
                ),
                PopupMenuItem<WebViewOptions>(
                  value: WebViewOptions.VIEW_REPOSITORY,
                  child: Text('View repository'),
                ),
              ];
            },
          ),
          // Refresh, copy url, share url, open in browser
        ],
      ),
      body: WebView(
        initialUrl: widget.contribution.url,
        onWebViewCreated: _onWebViewCreated,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  void _onWebViewCreated(WebViewController controller) {
    _controller = controller;
    setState(() {
      controllerReady = true;
    });
  }
}

enum WebViewOptions {
  RELOAD,
  COPY_URL,
  SHARE_URL,
  OPEN_EXTERNALLY,
  VIEW_REPOSITORY,
}
