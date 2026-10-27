import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants/app_colors.dart';

class ProgramCategoriesView extends StatelessWidget {
  const ProgramCategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Bands',
        'subtitle': 'Explore our range of classic bands',
        'icon': Icons.circle_outlined,
        'route': '/bands_price_sheet',
      },
      {
        'title': 'Curve bands',
        'subtitle': 'Price sheet for Curved Band Program',
        'icon': Icons.gesture_outlined,
        'route': '/curve_bands_price_sheet',
      },
      {
        'title': 'Bracelets',
        'subtitle': 'Elegant diamond and gold bracelets',
        'icon': Icons.watch_outlined,
        'route': '/bracelets_price_sheet',
      },
      {
        'title': 'Studs',
        'subtitle': 'Timeless diamond stud earrings',
        'icon': Icons.diamond_outlined,
        'route': '/studs_price_sheet',
      },
      // {
      //   'title': 'Necklaces (DBY)',
      //   'subtitle': 'Diamonds by the Yard necklaces',
      //   'icon': Icons.linear_scale,
      //   'route': null,
      // },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F5),
      appBar: AppBar(
        title: const Text('Program Categories'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.04),
            color: Colors.white,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                if (cat['route'] != null) {
                  Navigator.pushNamed(context, cat['route'] as String);
                } else {
                  _showComingSoonDialog(context, cat['title'] as String);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryButton.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: cat['icon'] is IconData
                          ? Icon(
                              cat['icon'] as IconData,
                              color: AppColors.primaryButton,
                              size: 24,
                            )
                          : FaIcon(
                              cat['icon'],
                              color: AppColors.primaryButton,
                              size: 24,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat['title'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cat['subtitle'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'The price sheet and details for $title program will be available soon.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryButton,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
