import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'main.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  CameraImage cameraImage;
  CameraController cameraController;
  bool isWorking = false;
  String result = "result";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initCamera();
    loadModel();
  }

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted)
      {
        return;
      }

      setState(() {
        cameraController.startImageStream((imageFromStream) => {
          if(!isWorking)
          {
            isWorking = true,
            cameraImage = imageFromStream,
            runModelOnFrame()
          }
        });
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt"
    );
  }

  runModelOnFrame() async {
    if(cameraImage != null)
    {
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: cameraImage.planes.map((plane) {
            return plane.bytes;
          }).toList(),
        imageWidth: cameraImage.width,
        imageHeight: cameraImage.height,
        imageStd: 127.5,
        imageMean: 127.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.1,
        asynch: true
      );

      result = "";

      recognitions.forEach((response) {
        result += response["label"] + "\n";
      });

      setState(() {
        result;
      });

      isWorking = false;
    }
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Center(
            child: Text(
              result,
              style: TextStyle(
                backgroundColor: Colors.black54,
                color: Colors.white,
                fontSize: 30.0
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Positioned(
              top: 0,
              left: 0,
              width: size.width,
              height: size.height - 100,
              child: Container(
                  height: size.height - 100,
                  child: (!cameraController.value.isInitialized)
                      ? Container()
                      : AspectRatio(
                    aspectRatio: cameraController.value.aspectRatio,
                    child: CameraPreview(cameraController),
                  )
              ),
          )
        ],
      ),
    );
  }
}
