import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.image});

  final MemoryImage? image;

  Future<void> _downloadImage(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/cropped_image.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image!.bytes);
      await GallerySaver.saveImage(imageFile.path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image saved to gallery')),
      );
    } catch (e) {
      print('Error saving image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cropped Image'),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 248, 252, 252),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            image != null
                ? Image.memory(
                    image!.bytes,
                  )
                : const Text('No image to display.'),
            SizedBox(
              height: s.height * .02,
            ),
            const Text("It's done!"),
            SizedBox(
              height: s.height * .02,
            ),
            GestureDetector(
              onTap: () => _downloadImage(context),
              child: Container(
                width: s.width * .6,
                height: s.height * .07,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade800,
                ),
                child: const Center(
                  child: Text(
                    "Download\ncropped image",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
