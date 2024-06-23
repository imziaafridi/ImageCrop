import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:profile_image_crop/utils/extensions.dart';

import 'cropIMG/image_croper.dart';
import 'cropIMG/result_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom crop example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Custom crop example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    required this.title,
    super.key,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CustomImageCropController controller;
  CustomCropShape _currentShape = CustomCropShape.Circle;
  CustomImageFit _imageFit = CustomImageFit.fillCropSpace;
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

  double _width = 16;
  double _height = 9;
  double _radius = 4;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _changeCropShape(CustomCropShape newShape) {
    setState(() {
      _currentShape = newShape;
    });
  }

  void _changeImageFit(CustomImageFit imageFit) {
    setState(() {
      _imageFit = imageFit;
    });
  }

  void _updateRatio() {
    setState(() {
      if (_widthController.text.isNotEmpty) {
        _width = double.tryParse(_widthController.text) ?? 16;
      }
      if (_heightController.text.isNotEmpty) {
        _height = double.tryParse(_heightController.text) ?? 9;
      }
      if (_radiusController.text.isNotEmpty) {
        _radius = double.tryParse(_radiusController.text) ?? 4;
      }
    });
    FocusScope.of(context).unfocus();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  void _resetImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.white.withOpacity(0.18),
                child: const Center(
                  child: Text(
                    'FLUTTER IMAGE CROP',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.purple.shade200,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            // width: double.infinity,
            // height: s.height * .5,
            child: _image == null
                ? Center(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 15,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.white.withOpacity(.6),
                          borderRadius: BorderRadius.circular(6),
                          gradient: const LinearGradient(
                            colors: [
                              Colors.white70,
                              Colors.white24,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        width: s.width * .8,
                        height: s.height * .4,
                        child: DottedBorder(
                          color: Colors.black54,
                          strokeWidth: 1.4,
                          dashPattern: const [6, 4.5], // Pattern of the dashes
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(6),
                          child: SizedBox(
                            width: s.width * .8,
                            height: s.height * .4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.4),
                                    borderRadius: BorderRadius.circular(12),
                                    // border: Border.all(color: Colors.black),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Image.asset(
                                        'assets/images/img-download.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: s.height * .04,
                                ),
                                GestureDetector(
                                  onTap: () => _pickImage(ImageSource.gallery),
                                  child: Container(
                                    width: double.infinity,
                                    height: s.height * .072,
                                    margin: EdgeInsets.only(
                                        left: s.width * .098,
                                        right: s.width * .098),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.shade800,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Upload image",
                                        // textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15.5,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : ImageCroper(
                    controller: controller,
                    image: _image,
                    currentShape: _currentShape,
                    width: _width,
                    height: _height,
                    radius: _radius,
                    imageFit: _imageFit),
          ),
          if (_image != null)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 10, sigmaY: 10, tileMode: TileMode.clamp),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: controller.reset),
                    IconButton(
                      icon: const Icon(Icons.zoom_in),
                      onPressed: () {
                        controller.addTransition(
                          CropImageData(scale: 1.33),
                        );
                      },
                    ),
                    IconButton(
                        icon: const Icon(Icons.zoom_out),
                        onPressed: () => controller
                            .addTransition(CropImageData(scale: 0.75))),
                    IconButton(
                        icon: const Icon(Icons.rotate_left),
                        onPressed: () => controller
                            .addTransition(CropImageData(angle: -pi / 4))),
                    IconButton(
                        icon: const Icon(Icons.rotate_right),
                        onPressed: () => controller
                            .addTransition(CropImageData(angle: pi / 4))),
                    PopupMenuButton(
                      icon: const Icon(Icons.crop_original),
                      onSelected: _changeCropShape,
                      itemBuilder: (BuildContext context) {
                        return CustomCropShape.values.map(
                          (shape) {
                            return PopupMenuItem(
                              value: shape,
                              child: getShapeIcon(shape),
                            );
                          },
                        ).toList();
                      },
                    ),
                    PopupMenuButton(
                      icon: const Icon(Icons.fit_screen),
                      onSelected: _changeImageFit,
                      itemBuilder: (BuildContext context) {
                        return CustomImageFit.values.map(
                          (imageFit) {
                            return PopupMenuItem(
                              value: imageFit,
                              child: Text(imageFit.label),
                            );
                          },
                        ).toList();
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.crop,
                        color: Colors.green,
                      ),
                      onPressed: () async {
                        final image = await controller.onCropImage();
                        if (image != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ResultScreen(image: image)));
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: _resetImage,
                    ),
                  ],
                ),
              ),
            ),
          if (_currentShape == CustomCropShape.Ratio) ...[
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _widthController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Width'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Height'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _radiusController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Radius'),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: _updateRatio,
                    child: const Text('Update Ratio'),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget getShapeIcon(CustomCropShape shape) {
    switch (shape) {
      case CustomCropShape.Circle:
        return const Icon(Icons.circle_outlined);
      case CustomCropShape.Square:
        return const Icon(Icons.square_outlined);
      case CustomCropShape.Ratio:
        return const Icon(Icons.crop_16_9_outlined);
    }
  }
}
