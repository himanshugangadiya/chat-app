import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommonCacheNetworkImage extends StatelessWidget {
  final String imageUrl;
  const CommonCacheNetworkImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl.toString(),
      fit: BoxFit.cover,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
