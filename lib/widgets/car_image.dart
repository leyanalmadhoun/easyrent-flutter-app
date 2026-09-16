import 'package:flutter/material.dart';

class CarImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CarImage({super.key, this.url, this.width, this.height, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    final imageUrl = url?.trim() ?? '';
    if (imageUrl.isEmpty) {
      return Image.asset('assets/images/car.png', width: width, height: height, fit: fit);
    }
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : SizedBox(width: width, height: height, child: const Center(child: CircularProgressIndicator())),
      errorBuilder: (_, __, ___) => Image.asset('assets/images/car.png', width: width, height: height, fit: fit),
    );
  }
}
