import 'package:flutter/material.dart';
import '../data/product_images.dart';

class ProductImageHelper {
  static Widget getImage(String? filename, {double size = 40}) {
    final normalizedFilename = filename?.toLowerCase().trim();

    final match = allProductImages.where(
      (img) => img.file.toLowerCase() == normalizedFilename,
    ).toList();

    if (match.isEmpty || match.first.asset.isEmpty) {
      return Icon(Icons.eco, color: Colors.green, size: size * 0.7);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        match.first.asset,
        height: size,
        width: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.eco, color: Colors.green, size: size * 0.7),
      ),
    );
  }
}