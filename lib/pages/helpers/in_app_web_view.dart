import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebViewPage extends StatefulWidget {
  final String title, uri;

  const InAppWebViewPage({Key? key, required this.title, required this.uri})
      : super(key: key);

  @override
  _InAppWebViewPageState createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  int _stackIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xFF0C46DD),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Expanded(
          child: IndexedStack(
            index: _stackIndex,
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(widget.uri)),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform:
                  InAppWebViewOptions(useShouldOverrideUrlLoading: true),
                ),
                onLoadStop: (_, __) {
                  setState(() {
                    _stackIndex = 0;
                  });
                },
                onLoadError: (_, __, ___, ____) {
                  setState(() {
                    _stackIndex = 0;
                  });
                  //TODO: Show error alert message (Error in receive data from server)
                },
                onLoadHttpError: (_, __, ___, ____) {
                  setState(() {
                    _stackIndex = 0;
                  });
                  //TODO: Show error alert message (Error in receive data from server)
                },
              ),
              const Center(
                // height: 50,
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}