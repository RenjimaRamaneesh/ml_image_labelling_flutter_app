import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade100),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Image Recognition'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? image;
  late ImagePicker imagePicker;
  late ImageLabeler labeler;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker =ImagePicker();
     ImageLabelerOptions options = ImageLabelerOptions(confidenceThreshold: 0.6);
    labeler = ImageLabeler(options: options);
  }

  chooseImage() async {
    XFile? selecetedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if(selecetedImage != null){
      image = File(selecetedImage.path);
      performImageLabelling();
      setState(() {
        image;
      });
    }
  }

  captureImage()async {
    XFile? selecetedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if(selecetedImage != null){
      image = File(selecetedImage.path);
      performImageLabelling();
      setState(() {
        image;
      });
    }
  }

  String results = "";

  performImageLabelling() async {
    results = "";
    InputImage inputImage = InputImage.fromFile(image!);
    final List<ImageLabel> labels = await labeler.processImage(inputImage);

    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      print(text +" "+confidence.toString());
      results+= text +" "+confidence.toStringAsFixed(2)+"\n";
    }
    setState(() {
      results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                color: Colors.green.shade300,
                margin: EdgeInsets.all(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/2,
                  child: image == null
                      ? const Icon(
                          Icons.image_outlined,
                          color: Colors.black,
                          size: 150,
                        )
                      : Image.file(image!),
                ),
              ),

               Card(

                child: Container(
                  height: 100,
                  color: Colors.green.shade600,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      InkWell(child: const Icon(Icons.image,size: 50,),onTap: (){
                        chooseImage();
                      },),

                      InkWell(child: const Icon(Icons.camera,size: 50,),onTap: (){
                        captureImage();
                      },),
                    ],
                  ),
                ),
              ),
             /* ElevatedButton(onPressed: () {
                chooseImage();
              },
                  onLongPress: (){
                captureImage();
                  },
                  child: Text("Choose/Capture")),*/

              Card(
                margin: EdgeInsets.all(10),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.green.shade900,
                   width:MediaQuery.of(context).size.width ,
                  child: Text(results,style: TextStyle(fontSize: 12.0,color: Colors.white),),

              )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
