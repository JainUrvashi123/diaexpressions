import 'package:flutter/material.dart';
import 'components/dynamic_pdf_viewer.dart';

class BraceletsPriceSheetView extends StatelessWidget {
  const BraceletsPriceSheetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Bracelets Price Sheet'),
        elevation: 0,
      ),
      body: const DynamicPdfViewer(
        fileNameKeyword: 'bracelets_pricing',
        fallbackTitle: 'Bracelets Pricing',
      ),
    );
  }
}
