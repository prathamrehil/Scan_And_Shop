import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:scanandshop/recognizing.dart';
import 'package:scanandshop/scannedResult.dart';
import 'package:scanandshop/sidebar.dart';

class scan extends StatefulWidget {
  const scan({Key? key}) : super(key: key);

  @override
  State<scan> createState() => _scanState();
}

class _scanState extends State<scan> {
  int currentcamera = 0;
  var _selectedImage = null;
  String _recognizedText = "";
  late var controller = null;
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    availableCameras().then((List<CameraDescription> cameras) {
      controller =
          CameraController(cameras[currentcamera], ResolutionPreset.max);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }

        setState(() {
          isLoaded = true;
        });
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Scan and shop",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 75,
      ),
      body: Container(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isLoaded && controller.value.isInitialized)
              Container(
                height: Get.height * 0.75,
                child: Stack(
                  children: [
                    Container(
                        height: Get.height * 0.75,
                        width: Get.width,
                        child: CameraPreview(controller)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: GestureDetector(
                          onTap: () {
                            availableCameras()
                                .then((List<CameraDescription> cameras) {
                              isLoaded = false;
                              if (currentcamera == 0) {
                                currentcamera = 1;
                              } else {
                                currentcamera = 0;
                              }
                              controller = CameraController(
                                  cameras[currentcamera], ResolutionPreset.max);

                              controller.initialize().then((_) {
                                if (!mounted) {
                                  return;
                                }

                                setState(() {
                                  isLoaded = true;
                                });
                              });
                            });
                          },
                          child: Container(
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black.withOpacity(0.35),
                            ),
                            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Rotate",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.rotate_left_outlined,
                                    color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            Expanded(
              child: _captureControlRowWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _captureControlRowWidget() {
    final CameraController? cameraController = controller;

    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(12),
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              padding: EdgeInsets.all(5),
              decoration: new BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(40)),
              child: IconButton(
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      _selectedImage = image;
                    });
                    if (_selectedImage != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => recognizingImage(
                                image: _selectedImage,
                              )));
                    }
                  },
                  icon: Icon(
                    Icons.upload,
                    color: Colors.black,
                  ))),
          Container(
              padding: EdgeInsets.all(5),
              decoration: new BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(40)),
              child: IconButton(
                  onPressed: () {
                    onTakePictureButtonPressed();
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                  ))),
          controller?.value.flashMode == FlashMode.off
              ? IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.flash_off),
                  iconSize: 30,
                  onPressed: () {
                    onSetFlashModeButtonPressed(FlashMode.torch);
                  },
                )
              : IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.flash_on),
                  iconSize: 30,
                  onPressed: () {
                    onSetFlashModeButtonPressed(FlashMode.off);
                  },
                ),
        ],
      ),
    );
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          _selectedImage = file;
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => recognizingImage(
                  image: _selectedImage,
                )));
      }
    });
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });
  }
}
