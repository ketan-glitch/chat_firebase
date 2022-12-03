import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CustomWebView extends StatefulWidget {
  final String url, title;
  const CustomWebView({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  late String url;
  @override
  void initState() {
    super.initState();
    url = widget.url;
    if (!(url.startsWith('http'))) {
      if (!(url.startsWith('https://'))) {
        url = 'https://$url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log(url);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
        },
      ),
    );
  }
}
