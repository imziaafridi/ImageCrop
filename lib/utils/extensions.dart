import 'package:custom_image_crop/custom_image_crop.dart';

extension CustomImageFitExtension on CustomImageFit {
  String get label {
    switch (this) {
      case CustomImageFit.fillCropSpace:
        return 'Fill crop space';
      case CustomImageFit.fitCropSpace:
        return 'Fit crop space';
      case CustomImageFit.fillCropHeight:
        return 'Fill crop height';
      case CustomImageFit.fillCropWidth:
        return 'Fill crop width';
      case CustomImageFit.fillVisibleSpace:
        return 'Fill visible space';
      case CustomImageFit.fitVisibleSpace:
        return 'Fit visible space';
      case CustomImageFit.fillVisibleHeight:
        return 'Fill visible height';
      case CustomImageFit.fillVisibleWidth:
        return 'Fill visible width';
    }
  }
}
