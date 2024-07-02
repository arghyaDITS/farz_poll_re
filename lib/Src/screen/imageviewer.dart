import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {

  String imageURL;
  ImageViewer({Key? key, required this.imageURL}) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: false, // Set it to false
          boundaryMargin: EdgeInsets.all(10000),
          minScale: 0.5,
          maxScale: 2,
          child: Image.network('${widget.imageURL}',
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}