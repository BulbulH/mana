
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterecom/payments/config.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/woohttprequest.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPaypal extends StatefulWidget {
  final String token;
  final String initalUrl;
  final String executeUrl;

  WebViewPaypal(this.token, this.initalUrl, this.executeUrl);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewPaypal> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Stack(alignment: Alignment.topLeft,
          children: [
            WebView(
              initialUrl: widget.initalUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              // TODO(iskakaushik): Remove this when collection literals makes it to stable.
              // ignore: prefer_collection_literals
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet(),
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith(paypalRedirectUrls["return_url"])) {
                  Uri uri = Uri.dataFromString(request.url); //converts string to a uri
                  var payerId = uri.queryParameters["PayerID"]; // return value of parameter "param1" from uri

                  WooHttpRequest().paymentPaypalExecute(widget.token, payerId, widget.executeUrl).then((value) {
                    if(value) {
                      WooHttpRequest().putNewOrder("paypal","PayPal").then((value) {
                        Navigator.pushReplacementNamed(context, "/home");
                      });
                    }
                  });
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              gestureNavigationEnabled: true,
            ),
            GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 40),
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.arrow_back,
                    color: themeAppBarItems,
                    size: 25,),
                )
            ),
          ],
        );
      }),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

}