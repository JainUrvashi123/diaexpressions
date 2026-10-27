import 'package:flutter/material.dart';
import 'components/dynamic_pdf_viewer.dart';

class BandsPriceSheetView extends StatelessWidget {
  const BandsPriceSheetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Bands Price Sheet'),
        elevation: 0,
      ),
      body: const DynamicPdfViewer(
        fileNameKeyword: 'bands_pricing',
        fallbackTitle: 'Bands Pricing',
      ),
    );
  }
}
