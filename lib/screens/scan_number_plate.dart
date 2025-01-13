import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:parkey_employee/Fragment/approved_fragment.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../colors/CustomColors.dart';
import '../utils/Constants.dart';
import '../utils/UpperCaseFormatter.dart';


class ScanNumberPlate extends StatefulWidget {
  final PageController controller;
  const ScanNumberPlate({required this.controller,super.key});

  @override
  State<ScanNumberPlate> createState() => _ScanNumberPlateState();
}

class _ScanNumberPlateState extends State<ScanNumberPlate> with WidgetsBindingObserver{
  bool _isPermissionGranted = false;

  late final Future<void> _future;
  CameraController? _cameraController;
  int _pointers = 0;
  final textRecognizer = TextRecognizer();
  final TextEditingController vehicleNumberInputController =
  TextEditingController();
  double widthParent = 0.0;
  double heightParent = 0.0;
  double _currentZoom = 1.0; // Current zoom level
  double _scale = 1.0; // Current scale
  double _previousScale = 1.0;
  final regex = RegExp(r'[^\w]');
// Minimum zoom level supported by the camera

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    widthParent = MediaQuery.of(context).size.width;
    heightParent = MediaQuery.of(context).size.height;
    return SafeArea(child: Material(
      child: Column(
        children: [
          Expanded(child: GestureDetector(
      onScaleUpdate: _handleScaleUpdate,
             child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                return Stack(
                  children: [
                    if (_isPermissionGranted)
                      FutureBuilder<List<CameraDescription>>(
                        future: availableCameras(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            _initCameraController(snapshot.data!);
                            return Container(
                                width: widthParent,
                                child: CameraPreview(_cameraController!),);
                          } else {
                            return const LinearProgressIndicator();
                          }
                        },
                      ),
                    Scaffold(
                      backgroundColor: _isPermissionGranted ? Colors.transparent : null,
                      body: _isPermissionGranted ?
                      Stack(
                        children: [
                          // Full-screen blur overlay
                          Positioned.fill(
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),

                          // Clear rectangle area
                          Positioned.fill(
                            child: CustomPaint(
                              painter: ClearRectanglePainter(
                                rectWidth: widthParent * 0.95,
                                rectHeight: heightParent * 0.15,
                              ),
                            ),
                          ),

                          // Rectangle border
                          Center(
                            child: Container(
                              width: widthParent * 0.95,
                              height: heightParent * 0.15,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red, width: 2),
                              ),
                            ),
                          ),

                          // Scan button
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: ElevatedButton(
                                onPressed: _scanImage,
                                child: const Text('Capture'),
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.topRight,
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: (){
                                    setState(() {
                                      _currentZoom++;
                                      _currentZoom = (_currentZoom).clamp(1.0, 8.0);
                                      print('_currentZoom++'+_currentZoom.toString() );
                                      _cameraController!.setZoomLevel(_currentZoom);
                                    });
                                }, child: const Text('+', style: TextStyle(color: Colors.black, fontSize: 24))),
                                ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        _currentZoom--;
                                        _currentZoom = (_currentZoom).clamp(1.0, 8.0);
                                        print('_currentZoom--'+_currentZoom.toString() );
                                        _cameraController!.setZoomLevel(_currentZoom);
                                      });
                                    }, child: const Text('-', style: TextStyle(color: Colors.black, fontSize: 28)))
                              ],
                            ),
                          ),


                        ],
                      )
                          : Center(
                        child: Container(
                          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                          child: const Text(
                            'Camera permission denied',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(
                left: 20, right: 20, top: 20),
            child: Container(
                height: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Color(CustomColors.PURPLE_DARK),
                        width: 2)),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Image(
                          height: 15,
                          width: 15,
                          fit: BoxFit.contain,
                          image: AssetImage(
                              'assets/images/approved_fragment3.png'),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 7),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller:
                            vehicleNumberInputController,
                            inputFormatters: [
                              UpperCaseTextFormatter()
                            ],
                            maxLength: 10,
                            style: TextStyle(fontSize: 22),
                            onChanged: (text) {
                              if (text.length == 10) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                              counterText: '',
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: ElevatedButton(
                  onPressed: () async{
                    final SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                    sharedPreferences.setString(Constants.VEHICLE_NUMBER, vehicleNumberInputController.text);
                    widget.controller.jumpToPage(2);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    child: Container(
                      child: Text(
                        'Enter Car',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(CustomColors.PURPLE_DARK),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      // Set border radius
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(CustomColors.PURPLE_DARK), width: 2),
                    borderRadius: BorderRadius.circular(20.0)),
                child: ElevatedButton(
                  onPressed: () async{
                    final SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                    sharedPreferences.setString(Constants.VEHICLE_NUMBER, vehicleNumberInputController.text);
                    widget.controller.jumpToPage(4);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    child: Container(
                      child: Text(
                        'Exit Car',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(20.0), // Set border radius
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    print('gestrue' + details.scale.toString());
    if(_currentZoom <= 10){
      _currentZoom++;
    }

    setState(() {
      // Adjust the zoom level based on pinch
      if(details.scale != 1.0){
        _currentZoom = (details.scale).clamp(1.0, 8.0);
        if(_currentZoom < 10){
          _cameraController!.setZoomLevel(_currentZoom);// Keep zoom within limits
        }
      }
    });


  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;

    try {
      // Take a picture
      final pictureFile = await _cameraController!.takePicture();

      // Load the image as bytes
      final imageBytes = await File(pictureFile.path).readAsBytes();
      final originalImage = img.decodeImage(imageBytes);

      if (originalImage == null) {
        throw Exception("Failed to decode image");
      }

      // Get the screen size and calculate the rectangle coordinates
      final screenSize = MediaQuery.of(context).size;
      final centerX = screenSize.width / 2;
      final centerY = screenSize.height / 2;
      final rectWidth = widthParent*0.95; // Rectangle width
      final rectHeight = heightParent*0.15; // Rectangle height

      // Calculate scale factors between the preview and the captured image
      final scaleX = originalImage.width / screenSize.width;
      final scaleY = originalImage.height / screenSize.height;

      // Define the crop rectangle in the captured image's coordinate system
      final cropRect = Rect.fromCenter(
        center: Offset(centerX * scaleX, centerY * scaleY),
        width: rectWidth * scaleX,
        height: rectHeight * scaleY + 10,
      );

      // Crop the image to the rectangle
      final croppedImage = img.copyCrop(
        originalImage,
        x: cropRect.left.toInt(),
        y: cropRect.top.toInt(),
        width: cropRect.width.toInt(),
        height: cropRect.height.toInt(),
      );

      final croppedFile = File('${pictureFile.path}_cropped.jpg');
      await croppedFile.writeAsBytes(img.encodeJpg(croppedImage));

      // Create an InputImage from the cropped image
      final inputImage = InputImage.fromFilePath(croppedFile.path);

      // Initialize text recognizer
      final textRecognizer = TextRecognizer();

      // Process the image
      final recognizedText = await textRecognizer.processImage(inputImage);

      // Print recognized text
      String number = "";
      for (TextBlock block in recognizedText.blocks) {
       String cleanedString = block.text.replaceAll(regex, '');
       cleanedString = cleanedString.replaceAll('IND', '');
       number = number + cleanedString;
        print("Block"+block.text);
      }

      vehicleNumberInputController.setText(number);

      // Cleanup: Dispose the text recognizer
      textRecognizer.close();
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

// Helper function to crop the image
  Future<Uint8List> _cropImage({required File file, required Rect cropRect}) async {
    final imageBytes = await file.readAsBytes();
    final originalImage = img.decodeImage(imageBytes)!;

    // Crop the image using the rectangle
    final croppedImage = img.copyCrop(
      originalImage,
      x: cropRect.left.toInt(),
      y: cropRect.top.toInt(),
      width: cropRect.width.toInt(),
      height: cropRect.height.toInt(),
    );

    return Uint8List.fromList(img.encodeJpg(croppedImage));
  }
}

class ClearRectanglePainter extends CustomPainter {
  final double rectWidth;
  final double rectHeight;

  ClearRectanglePainter({required this.rectWidth, required this.rectHeight});

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for the semi-transparent overlay
    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Paint for the clear rectangle area
    final clearPaint = Paint()
      ..blendMode = BlendMode.clear;

    // Draw the full-screen overlay
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), overlayPaint);

    // Calculate the center rectangle coordinates
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Define the clear rectangle
    final clearRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: rectWidth,
      height: rectHeight,
    );

    // Clear the rectangle area
    canvas.drawRect(clearRect, clearPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
