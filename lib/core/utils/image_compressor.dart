// lib/core/utils/image_compressor.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompressor {
  static const int maxSizeBytes = 5 * 1024 * 1024; // 5MB
  
  static Future<String> compressToMax5Mb(String path) async {
    if (kIsWeb) {
      // على الويب، نعيد المسار الأصلي لأن الضغط يعمل بشكل مختلف
      print('🟡 [Compressor] On web, skipping file-based compression');
      return path;
    }
    
    // كود الضغط الأصلي للموبايل
    final file = File(path);
    final originalSize = await file.length();
    
    if (originalSize <= maxSizeBytes) {
      return path;
    }
    
    // ضغط الصورة
    final directory = await getTemporaryDirectory();
    final targetPath = '${directory.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      targetPath,
      quality: 80,
      minWidth: 1024,
      minHeight: 1024,
    );
    
    if (result != null) {
      final compressedSize = await result.length();
      if (compressedSize > maxSizeBytes) {
        // إذا كانت لا تزال كبيرة، ضغط أكثر
        return await _compressFurther(result.path);
      }
      return result.path;
    }
    
    return path;
  }
  
  static Future<String> _compressFurther(String path) async {
    final directory = await getTemporaryDirectory();
    final targetPath = '${directory.path}/compressed_final_${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      targetPath,
      quality: 60,
      minWidth: 800,
      minHeight: 800,
    );
    
    return result?.path ?? path;
  }
  
  // دالة للويب لضغط الصورة باستخدام ImagePicker Web
  static Future<Uint8List> compressForWeb(Uint8List bytes) async {
    if (!kIsWeb) return bytes;
    
    final result = await FlutterImageCompress.compressWithList(
      bytes,
      quality: 80,
      minWidth: 1024,
      minHeight: 1024,
    );
    
    return result ?? bytes;
  }
}