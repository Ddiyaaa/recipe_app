import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeDetails extends StatefulWidget {
  final String recipeDetailsUrl;

  RecipeDetails({required this.recipeDetailsUrl});

  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  late String finalUrl;
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    // Ensuring the URL uses HTTPS
    if (widget.recipeDetailsUrl.contains("http://")) {
      finalUrl = widget.recipeDetailsUrl.replaceAll("http://", "https://");
    } else {
      finalUrl = widget.recipeDetailsUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe Details"),
      ),
      body: WebView(
        initialUrl: finalUrl,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
