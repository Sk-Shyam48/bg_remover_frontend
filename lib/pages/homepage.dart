import 'package:background_master/controller/homepage_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/image_preview.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Background Remover',
          style: TextStyle(
            color: Color(0xFF1F1F1F),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hero text
                const Text(
                  "Upload an image to remove the background instantly!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 30),

                // Upload Area
                GestureDetector(
                  onTap: homeProvider.pickImage,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFF8F9FA),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          color: Colors.blueAccent.shade400,
                          size: 50,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          homeProvider.selectedImage == null
                              ? "Click to upload or choose an image"
                              : "Image selected successfully",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: homeProvider.selectedImage == null
                                ? Colors.grey.shade600
                                : Colors.green.shade600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Image Preview
                if (homeProvider.selectedImage != null)
                  ImagePreview(file: homeProvider.selectedImage!),

                const SizedBox(height: 30),

                // Remove Background Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        (homeProvider.selectedImage == null ||
                            homeProvider.isLoading)
                        ? null
                        : () => homeProvider.removeBackground(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0071E3),
                      disabledBackgroundColor: Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: homeProvider.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Remove Background',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 40),

                // Result Section
                _buildResultSection(homeProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultSection(HomeProvider provider) {
    if (provider.resultImage == null) {
      return const Text(
        'After processing, your image will appear here.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black54),
      );
    }

    if (provider.resultImage!.isEmpty) {
      return const Text(
        '⚠️ Something went wrong. Please try again.',
        style: TextStyle(color: Colors.redAccent),
      );
    }

    return Column(
      children: [
        const Text(
          'Result Preview',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF0071E3),
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            provider.resultImage!,
            height: 250,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
