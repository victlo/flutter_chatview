import 'package:flutter/material.dart';

enum SendPictureEnum {
  gallery('Photo Library', Icons.image),
  camera('Camera', Icons.camera_alt_outlined);

  final String text;

  final IconData icon;

  const SendPictureEnum(this.text, this.icon);
}
