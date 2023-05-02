import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  final Function(File image) onPickImage;

  const ImageInput({super.key, required this.onPickImage});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final image =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
      widget.onPickImage(_selectedImage!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(.2))),
      child: _selectedImage != null
          ? GestureDetector(
              onTap: _takePicture,
              child: Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          : TextButton.icon(
              onPressed: _takePicture,
              icon: const Icon(Icons.camera),
              label: const Text('Take Picture'),
            ),
    );
  }
}
