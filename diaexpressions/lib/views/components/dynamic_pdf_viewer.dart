import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/pdf_viewmodel.dart';

class DynamicPdfViewer extends StatefulWidget {
  final String fileNameKeyword;
  final String fallbackTitle;

  const DynamicPdfViewer({
    Key? key,
    required this.fileNameKeyword,
    required this.fallbackTitle,
  }) : super(key: key);

  @override
  State<DynamicPdfViewer> createState() => _DynamicPdfViewerState();
}

class _DynamicPdfViewerState extends State<DynamicPdfViewer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PdfViewModel>(context, listen: false).fetchPdfs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryButton,
            ),
          );
        }

        if (vm.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load pricing sheet',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vm.error!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryButton,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => vm.fetchPdfs(force: true),
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: Text(
                      'Retry',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final pdf = vm.getPdfByFileNameKeyword(widget.fileNameKeyword);

        if (pdf == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.picture_as_pdf_outlined,
                    color: Colors.grey,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pricing Sheet Not Found',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The requested pricing sheet "${widget.fallbackTitle}" could not be located on the server.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryButton,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => vm.fetchPdfs(force: true),
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: Text(
                      'Refresh List',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SfPdfViewer.network(pdf.url);
      },
    );
  }
}
