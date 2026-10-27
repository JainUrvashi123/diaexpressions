import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/auth_viewmodel.dart';

class UpdateBanner extends StatelessWidget {
  const UpdateBanner({Key? key}) : super(key: key);

  Future<void> _launchUpdateUrl(BuildContext context, AuthViewModel auth) async {
    final isAndroid = Platform.isAndroid;
    String? urlString;

    if (isAndroid) {
      urlString = auth.playstoreUrl ?? 'https://play.google.com/store/apps/details?id=com.diaexp.app';
    } else {
      urlString = auth.appstoreUrl ?? 'https://apps.apple.com/in/app/diaexpressions/id1509711851';
    }

    final url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch app store link.')),
        );
      }
    } catch (e) {
      debugPrint('Error launching update URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);
    if (!auth.updateRequired) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: GestureDetector(
        onTap: () => _launchUpdateUrl(context, auth),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.12), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left side: circular icon background
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sync,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              
              // Center side: titles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Update Available',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Enjoy a more seamless shopping experience',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.black54,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              
              // Right side: New pill badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00B074),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'New',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              // Right side: chevron icon
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFFF4874),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
