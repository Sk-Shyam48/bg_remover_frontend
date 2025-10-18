import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../service/backend_service.dart';

/// Provider for managing image selection and background removal state.
class HomeProvider with ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  Uint8List? _resultImage;
  bool _isLoading = false;

  File? get selectedImage => _selectedImage;
  Uint8List? get resultImage => _resultImage;
  bool get isLoading => _isLoading;

  /// Pick image from gallery.
  Future<void> pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (picked == null) return;

      _selectedImage = File(picked.path);
      _resultImage = null; // Reset previous result
      notifyListeners();
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  /// Send image to backend for background removal.
  Future<void> removeBackground(BuildContext context) async {
    if (_selectedImage == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await BackendService.removeBackground(_selectedImage!);

      if (!context.mounted) return;

      if (result == null || result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove background.')),
        );
        _resultImage = Uint8List(0);
      } else {
        _resultImage = result;
      }
    } catch (e) {
      debugPrint('Error removing background: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
