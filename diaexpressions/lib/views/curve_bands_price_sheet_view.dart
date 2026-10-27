import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import 'components/dynamic_pdf_viewer.dart';

class CurveBandsPriceSheetView extends StatelessWidget {
  const CurveBandsPriceSheetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Curved Band Price Sheet'),
          bottom: TabBar(
            labelColor: AppColors.primaryButton,
            unselectedLabelColor: Colors.black54,
            indicatorColor: AppColors.primaryButton,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(text: '10K'),
              Tab(text: '14K'),
              Tab(text: '18K'),
              Tab(text: 'PLATINUM'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DynamicPdfViewer(
              fileNameKeyword: '10K Curved',
              fallbackTitle: '10K Curved Band Prices',
            ),
            DynamicPdfViewer(
              fileNameKeyword: '14K Curved',
              fallbackTitle: '14K Curved Band Prices',
            ),
            DynamicPdfViewer(
              fileNameKeyword: '18K Curved',
              fallbackTitle: '18K Curved Band Prices',
            ),
            DynamicPdfViewer(
              fileNameKeyword: 'PLATINUM Curved',
              fallbackTitle: 'PLATINUM Curved Band Prices',
            ),
          ],
        ),
      ),
    );
  }
}
