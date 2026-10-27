import 'package:flutter/material.dart';
import 'components/dynamic_pdf_viewer.dart';

class StudsPriceSheetView extends StatelessWidget {
  const StudsPriceSheetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Studs Price Sheet'),
        elevation: 0,
      ),
      body: const DynamicPdfViewer(
        fileNameKeyword: 'studs_pricing',
        fallbackTitle: 'Studs Pricing',
      ),
    );
  }
}
