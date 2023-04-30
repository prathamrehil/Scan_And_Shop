import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

final ChromeSafariBrowser browser = MyChromeSafariBrowser();

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: Get.width * 0.7,
      height: Get.height,
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: 300,
                child: Image.asset(
                  "assets/textlogo.png",
                ),
              ),
              SizedBox(height: 20),
              Text("Packages used",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () async {
                    openWebsite("https://pub.dev/packages/google_ml_kit");
                  },
                  child: Text("Google ML Kit",
                      style: TextStyle(
                          color: Color(0xff5F5EFE),
                          fontSize: 18,
                          fontWeight: FontWeight.w400))),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () async {
                    openWebsite("https://pub.dev/packages/camera");
                  },
                  child: Text("Camera",
                      style: TextStyle(
                          color: Color(0xff5F5EFE),
                          fontSize: 18,
                          fontWeight: FontWeight.w400))),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () async {
                    openWebsite("https://pub.dev/packages/image_picker");
                  },
                  child: Text("Image picker",
                      style: TextStyle(
                          color: Color(0xff5F5EFE),
                          fontSize: 18,
                          fontWeight: FontWeight.w400))),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () async {
                    openWebsite("https://pub.dev/packages/tflite");
                  },
                  child: Text("TFLite",
                      style: TextStyle(
                          color: Color(0xff5F5EFE),
                          fontSize: 18,
                          fontWeight: FontWeight.w400))),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () async {
                    openWebsite(
                        "https://pub.dev/packages/flutter_inappwebview");
                  },
                  child: Text("In App WebView",
                      style: TextStyle(
                          color: Color(0xff5F5EFE),
                          fontSize: 18,
                          fontWeight: FontWeight.w400))),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () async {
                    openWebsite("https://pub.dev/packages/firebase_core");
                  },
                  child: Text("Firebase",
                      style: TextStyle(
                          color: Color(0xff5F5EFE),
                          fontSize: 18,
                          fontWeight: FontWeight.w400))),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () async {
                    openWebsite("https://pub.dev/packages/get");
                  },
                  child: Text("Get",
                      style: TextStyle(
                          color: Color(0xff5F5EFE),
                          fontSize: 18,
                          fontWeight: FontWeight.w400))),
              SizedBox(height: 20),
            ],
          ),
          Column(
            children: [
              Text(
                "Developed with ❤️ by ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: Text("- Pratham Rehil"),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: Text("- Rishit Mathur"),
              ),
            ],
          )
        ],
      ),
    ));
  }

  void openWebsite(String url) async {
    await browser.open(
        url: Uri.parse(url),
        options: ChromeSafariBrowserClassOptions(
            android: AndroidChromeCustomTabsOptions(
                shareState: CustomTabsShareState.SHARE_STATE_OFF),
            ios: IOSSafariOptions(barCollapsingEnabled: true)));
  }
}

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
