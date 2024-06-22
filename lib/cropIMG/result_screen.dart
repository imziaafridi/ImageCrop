import 'dart:io';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cropped Image'),
        actions: [
          IconButton(
              icon: const Icon(Icons.download),
              onPressed: () async {
                await _downloadImage(context);
              }),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: image != null
              ? Image.memory(
                  image!.bytes,
                )
              : const Text('No image to display.'),
        ),
      ),
    );
  }
}
