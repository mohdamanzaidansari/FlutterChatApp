import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function picImageCallback;
  const UserImagePicker({Key key, this.picImageCallback}) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _image;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.picImageCallback(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: _image != null ? FileImage(_image) : null,
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          textColor: Theme.of(context).primaryColor,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
