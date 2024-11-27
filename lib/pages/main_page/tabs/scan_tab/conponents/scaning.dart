import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:camera/camera.dart';
import 'package:camera_process/camera_process.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

List<CameraDescription> cameras = [];


class Scaning extends StatefulWidget {
  final Function(String) toCheck;
  const Scaning({super.key,required this.toCheck});

  @override
  State<Scaning> createState() => _ScaningState();
}

class _ScaningState extends State<Scaning> {
  CameraController? _controller;
  TextDetector textDetector = CameraProcess.vision.textDetector();
  final BarcodeDetector barcodeDetector = GoogleVision.instance.barcodeDetector();
  bool isBusy=false;
  bool isCamera=false;

  toogleCamera(){
    if(isCamera){
      isCamera=false;
      _controller?.stopImageStream();
    }else{
      startCamera();
    }
     setState(() {});
  }

  startCamera()async{
    cameras = await availableCameras();
      if(_controller==null){
        final camera = cameras[0];
        _controller = CameraController(
          camera,
          ResolutionPreset.high,
          enableAudio: false,
          fps: 60
        );
      }
      
      await _controller?.initialize();
      if (!mounted) {
          return;
        }
        isCamera=true;
        _controller?.startImageStream(_processCameraImage);
        setState(() {});
    
    
    
    
  }
  @override
  void dispose() async {
    super.dispose();
    await textDetector.close();
  }




  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Builder(
      builder: (context) {
        
        if(isCamera){
          return Expanded(
            child:  Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: width-32,
                    height: width+100,
                    child: CameraPreview(_controller!)
                  ),
                  Positioned(
                    bottom: 10,
                    child: GestureDetector(
                      onTap: toogleCamera,
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        alignment: Alignment.center,
                        child: Text("Отмена"),
                      ),
                    ),
                  )
                ],
              ),
            
          );
        }
        return  GestureDetector(
          onTap:toogleCamera,
          child: Container(
                    width: width-32,
                    height: width-32,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(168, 201, 255, 1),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset("assets/svg/filter_center_focus.svg")
                  ),
        );
      },
    );
  }

  Map<String,int> counter={

  };
  Future _processCameraImage(CameraImage image) async {
    try {
      final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[0];
    final imageRotation =
        InputImageRotationMethods.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.Rotation_0deg;

    final inputImageFormat =
        InputImageFormatMethods.fromRawValue(image.format.raw) ??
            InputImageFormat.NV21;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    processImage(inputImageData,bytes,image);
    } catch (e) {
      print("ERROR _processCameraImage");
      print(e);
    }
    
  }
  //    555555
  Future<void> processImage(InputImageData inputImageData,Uint8List bytes,CameraImage image) async {
    try {
      if (isBusy) return;
    isBusy = true;

    final inputImage =
    InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    GoogleVisionImage imageForBarcode = GoogleVisionImage.fromBytes(inputImage.bytes!,GoogleVisionImageMetadata(size: Size(image.width.toDouble(), image.height.toDouble())));
    final List<Barcode> barcodes = await barcodeDetector.detectInImage(imageForBarcode);
    print(barcodes.length);
    barcodes.forEach((element) {
      print(element.displayValue);
    },);
    if(barcodes.isNotEmpty&& barcodes[0].displayValue!=null && barcodes[0].displayValue!.length>=3){
      
      toogleCamera();
        return widget.toCheck(barcodes[0].displayValue!);
    }
    final recognisedText = await textDetector.processImage(inputImage);
    RegExp regex = RegExp(r'\d{3,5}');
    
    
    for (var element in recognisedText.blocks) { 
     //print(element.text);
     RegExpMatch? match = regex.firstMatch(element.text);
     List<String> dotSplit= element.text.split(".");
      if(match!=null && dotSplit.length<2){
        var key=element.text.substring(match.start,match.end);
        if(counter[key]==null){
          counter[key]=1;
        }else{
          counter[key]=counter[key]!+1;
        }
        
      }
      
    }
    //print(counter.toString());
    counter.forEach((key, value) { 
      if(value>=5){
        inspect(key);
        toogleCamera();
        return widget.toCheck(key);
      }
    });
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
    } catch (e) {
      print("ERROR processImage");
      print(e);
    }
  }
}