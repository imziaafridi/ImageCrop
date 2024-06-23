import 'dart:io';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageCroper extends StatelessWidget {
  const ImageCroper({
    super.key,
    required this.controller,
    required File? image,
    required CustomCropShape currentShape,
    required double width,
    required double height,
    required double radius,
    required CustomImageFit imageFit,
  })  : _image = image,
        _currentShape = currentShape,
        _width = width,
        _height = height,
        _radius = radius,
        _imageFit = imageFit;

  final CustomImageCropController controller;
  final File? _image;
  final CustomCropShape _currentShape;
  final double _width;
  final double _height;
  final double _radius;
  final CustomImageFit _imageFit;

  @override
  Widget build(BuildContext context) {
    return CustomImageCrop(
        backgroundColor: Colors.transparent,
        cropController: controller,
        image: FileImage(_image!, scale: 1),
        shape: _currentShape,
        ratio: _currentShape == CustomCropShape.Ratio
            ? Ratio(width: _width, height: _height)
            : null,
        canRotate: true,
        canMove: true,
        canScale: true,
        borderRadius: _currentShape == CustomCropShape.Ratio ? _radius : 0,
        customProgressIndicator: const CupertinoActivityIndicator(),
        imageFit: _imageFit,
        pathPaint: Paint()
          ..color = Colors.transparent
          // ..strokeWidth = 2.0
          ..style = PaintingStyle.fill
        // ..strokeJoin = StrokeJoin.round,
        );
  }
}
