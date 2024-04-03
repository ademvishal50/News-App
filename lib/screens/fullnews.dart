import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FullNewsPage extends StatelessWidget {
  final String url;

  const FullNewsPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Full Article",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
