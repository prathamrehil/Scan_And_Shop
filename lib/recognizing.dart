import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanandshop/scan.dart';
import 'package:scanandshop/scannedResult.dart';
import 'package:tflite/tflite.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class recognizingImage extends StatefulWidget {
  final XFile image;
  const recognizingImage({required this.image});

  @override
  State<recognizingImage> createState() => _recognizingImageState();
}

class _recognizingImageState extends State<recognizingImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    barcodescan(context);
    return Scaffold(
      body: Container(
        height: Get.height,
        child: Stack(
          children: [
            Image.file(
              io.File(widget.image.path),
              height: Get.height,
              width: Get.width,
              fit: BoxFit.cover,
            ),
            Container(
              height: Get.height,
              width: Get.width,
              color: Colors.black.withOpacity(0.3),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 30,
                  ),
                  Text("Recognizing",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void barcodescan(BuildContext context) async {
    final InputImage inputImage =
        InputImage.fromFile(io.File(widget.image.path));
    final List<BarcodeFormat> formats = [BarcodeFormat.all];
    final barcodeScanner = BarcodeScanner(formats: formats);
    final List<Barcode> barcodes =
        await barcodeScanner.processImage(inputImage);
    var barcodeUrl;
    for (Barcode barcode in barcodes) {
      final BarcodeType type = barcode.type;
      switch (type) {
        case BarcodeType.url:
          barcodeUrl = barcode.rawValue;
          break;
        default:
          break;
      }
    }
    if (barcodeUrl != null) {
      log("barcode not null");
      log(barcodeUrl);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => scannedResult(
                scannedText: barcodeUrl,
                isBarcode: true,
              )));
    } else {
      detectText(context);
    }
  }

  void detectText(BuildContext context) async {
    final InputImage inputImage;
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer
        .processImage(InputImage.fromFile(io.File(widget.image.path)));

    String text = recognizedText.text;

    textRecognizer.close();
    text = text.replaceAll("\n", " ");
    List<String> splitted = text.split(" ");
    if (splitted.length > 5) {
      splitted = splitted.sublist(0, 5);
    }
    text = splitted.join(" ");
    if (text != "" && text.length > 10) {
      log("text detected");
      log(text);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => scannedResult(
                scannedText: text,
              )));
    } else {
      detectObject(context, text);
    }
  }

  void detectObject(BuildContext context, String text) async {
    log("before detecting");
    String? res = await Tflite.loadModel(
        model: "assets/mobilenet_v1_1.0_224.tflite",
        labels: "assets/mobilenet_v1_1.0_224.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
    var recognitions = await Tflite.runModelOnImage(
        path: widget.image.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );
    String reconizedText = "";
    if ((recognitions!.length as dynamic) > 0) {
      num highestConfidence = 0;
      for (var recognition in recognitions) {
        if (recognition["confidence"] > highestConfidence) {
          highestConfidence = recognition["confidence"];
          reconizedText = recognition["label"];
        }
      }
    }
    if (((recognitions!.length as dynamic) == 0) && text == "") {
      Get.back();
    } else {
      log(res ?? "");
      log(recognitions.toString());
      log("after detecting");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => scannedResult(
                scannedText: reconizedText + " -" + text,
              )));
      await Tflite.close();
    }
  }
}
