import 'package:flutter/material.dart';

class ViewDocumentPage extends StatelessWidget {
  final String documentUrl;
  ViewDocumentPage({required this.documentUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Document')),
      body: Center(child: Text('Document: $documentUrl')),
    );
  }
}