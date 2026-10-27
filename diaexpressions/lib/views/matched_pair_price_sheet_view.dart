import 'package:flutter/material.dart';
import 'components/dynamic_pdf_viewer.dart';

class MatchedPairPriceSheetView extends StatelessWidget {
  const MatchedPairPriceSheetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Matched Pair Price Sheet'),
        elevation: 0,
      ),
      body: const DynamicPdfViewer(
        fileNameKeyword: 'matched_pairs',
        fallbackTitle: 'Matched Pairs Pricing',
      ),
    );
  }
}
