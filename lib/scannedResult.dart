import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:scanandshop/scan.dart';

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  @override
  void onCompletedInitialLoad() {
    print("ChromeSafari browser initial load completed");
  }

  @override
  void onClosed() {
    print("ChromeSafari browser closed");
  }
}

class scannedResult extends StatefulWidget {
  final String scannedText;
  final bool isBarcode;
  const scannedResult({required this.scannedText, this.isBarcode = false});

  @override
  State<scannedResult> createState() => _scannedResultState();
}

class _scannedResultState extends State<scannedResult> {
  final ChromeSafariBrowser browser = new MyChromeSafariBrowser();
  bool isWebsiteLoading = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Container(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse((!widget.isBarcode)
                      ? "https://www.google.com/search?tbm=shop&q=${widget.scannedText}"
                      : widget.scannedText)),
              onLoadStart: (InAppWebViewController controller, Uri? url) async {
                setState(() {
                  isWebsiteLoading = true;
                });
              },
              onLoadStop: (InAppWebViewController controller, Uri? url) async {
                if (url.toString().contains("google.com")) {
                  await controller.evaluateJavascript(
                      source:
                          """var didyoumean = document.getElementsByClassName('_-ME');
                  for (var i = 0; i < didyoumean.length; i ++) {
                    didyoumean[i].style.display = 'none';
                    }
                    var searchbar = document.getElementsByClassName('Fh5muf');
                  for (var i = 0; i < searchbar.length; i ++) {
                    searchbar[i].style.display = 'none';
                    }

                    var yoursearch = document.getElementsByClassName('_-LI mnr-c');
                  for (var i = 0; i < yoursearch.length; i ++) {
                    yoursearch[i].style.display = 'none';
                    }

                    var trendingsearch = document.getElementsByClassName('sh-rq__result-group');
                  for (var i = 0; i < trendingsearch.length; i ++) {
                    trendingsearch[i].style.display = 'none';
                    }

                    var footer = document.getElementsByClassName('sh-fo__root');
                  for (var i = 0; i < footer.length; i ++) {
                    footer[i].style.display = 'none';
                    }
                    document.getElementById("cnt").style.padding = '50px 0px 0px 0px';

                    """);
                } else {
                  if (!(widget.isBarcode)) {
                    await browser.open(
                        url: url!,
                        options: ChromeSafariBrowserClassOptions(
                            android: AndroidChromeCustomTabsOptions(
                                shareState:
                                    CustomTabsShareState.SHARE_STATE_OFF),
                            ios: IOSSafariOptions(barCollapsingEnabled: true)));
                    controller.goBack();
                  }
                }
                Future.delayed(Duration(milliseconds: 2000), () {
                  setState(() {
                    isWebsiteLoading = false;
                  });
                });
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Visibility(
              visible: isWebsiteLoading,
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    ));
  }
}
