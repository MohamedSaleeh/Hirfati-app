import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageUtils {
  static Widget buildPreview(String? path, {double? width, double? height}) {
    if (path == null || path.isEmpty) {
      return _buildPlaceholder(width, height);
    }

    if (kIsWeb) {
      return _buildWebImage(path, width, height);
    }
    return _buildMobileImage(path, width, height);
  }

  static Widget _buildWebImage(String path, double? width, double? height) {
    return Image.network(
      path,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(width, height),
    );
  }

  static Widget _buildMobileImage(String path, double? width, double? height) {
    return Image.file(
      File(path),
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(width, height),
    );
  }

  static Widget _buildPlaceholder(double? width, double? height) {
    return Container(
      width: width ?? 88,
      height: height ?? 88,
      color: Colors.grey.shade200,
      child: const Icon(Icons.broken_image),
    );
  }
}