import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/quote_viewmodel.dart';
import 'quotes_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import '../services/metal_service.dart';
import 'admin_enquiries_view.dart';
class HomeView extends StatefulWidget {

  final Function(int)? onNavigate;
  const HomeView({Key? key, this.onNavigate}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isLoadingProfile = true;
  String? _cadGalleryName;
  String? _cadGalleryStatus;
  
  Map<String, dynamic>? _metalPrices;
  bool _isLoadingMetal = true;
  bool _showMetalPrices = true;

  bool get _isAdmin {
    final auth = context.read<AuthViewModel>();
    return auth.user?.userType == '1';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProfile();
      _fetchMetalPrices();
    });
  }

  Future<void> _fetchProfile() async {
    final auth = context.read<AuthViewModel>();
    final profile = await auth.fetchProfile();
    if (mounted) {
      setState(() {
        _cadGalleryName = profile?.cadGalleryName;
        _cadGalleryStatus = profile?.cadGalleryStatus;
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _fetchMetalPrices() async {
    final metalService = MetalService();
    final prices = await metalService.getMetalPrices();
    if (mounted) {
      setState(() {
        _metalPrices = prices;
        _isLoadingMetal = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _showMetalPrices = true;
      _isLoadingMetal = true;
    });
    await Future.wait([
      _fetchProfile(),
      _fetchMetalPrices(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F5),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: const Color(0xFFC78B6C),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                children: [
                  if (!_isLoadingMetal && _metalPrices != null && _showMetalPrices)
                    Container(
                      height: 35,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBEADB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFC78B6C), width: 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              child: Marquee(
                                text: 'Gold: \$${_metalPrices!['gold']}   |   Platinum: \$${_metalPrices!['platinum']}   |   Silver: \$${_metalPrices!['silver']}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFC78B6C),
                                  fontSize: 14,
                                ),
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                blankSpace: 50.0,
                                velocity: 40.0,
                                startPadding: 10.0,
                                accelerationDuration: const Duration(seconds: 1),
                                accelerationCurve: Curves.linear,
                                decelerationDuration: const Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showMetalPrices = false;
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(Icons.close, size: 18, color: Color(0xFFC78B6C)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 150,
                    child: _buildWelcomeBanner(),
                  ),
                  const SizedBox(height: 16),
                  _isAdmin ? _buildAdminDashboardList(context) : _buildDashboardGrid(context),
                  if (!_isAdmin) ...[
                    const SizedBox(height: 16),
                    _buildContactCard(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminDashboardList(BuildContext context) {
    return Column(
      children: [
        Consumer<QuoteViewModel>(
          builder: (context, quoteVM, _) {
            final count = quoteVM.unreadAdminEnquiriesCount;
            return _buildAdminListItem(
              context,
              title: 'All Enquiries',
              subtitle: 'Manage custom design enquiries',
              icon: Icons.admin_panel_settings_outlined,
              iconColor: Colors.redAccent,
              bgColor: const Color(0xFFFFEBEE),
              badgeCount: count,
              onTap: () => Navigator.pushNamed(context, '/admin_enquiries'),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildAdminListItem(
          context,
          title: 'Quote Enquiries',
          subtitle: 'View and manage quote enquiries',
          icon: Icons.format_quote_outlined,
          iconColor: const Color(0xFF6B8BBE),
          bgColor: const Color(0xFFE0EEFE),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminEnquiriesView(initialStatus: 'Quote'),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildAdminListItem(
          context,
          title: 'Order Enquiries',
          subtitle: 'View and manage order enquiries',
          icon: Icons.shopping_bag_outlined,
          iconColor: const Color(0xFFB577A8),
          bgColor: const Color(0xFFFDE8F6),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminEnquiriesView(initialStatus: 'Order'),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildAdminListItem(
          context,
          title: 'Completed Enquiries',
          subtitle: 'View all completed enquiries',
          icon: Icons.assignment_turned_in_outlined,
          iconColor: const Color(0xFFA58564),
          bgColor: const Color(0xFFF7E9DA),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminEnquiriesView(initialStatus: 'Completed'),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAdminListItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          '$badgeCount',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.chevron_right, color: iconColor, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/Custom_Banner.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.65,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildDashboardItem(
          context,
          title: 'Jewelry',
          subtitle: 'Manage your\njewelry',
          icon: FontAwesomeIcons.gem,
          iconColor: const Color(0xFFC78B6C),
          bgColor: const Color(0xFFFBEADB),
          onTap: () {
            if (widget.onNavigate != null) {
              widget.onNavigate!(1);
            } else {
              Navigator.pushNamed(context, '/jewelry');
            }
          },
        ),
        _buildDashboardItem(
          context,
          title: 'Program',
          subtitle: 'Manage your\nprograms',
          icon: Icons.menu_book_outlined,
          iconColor: const Color(0xFFA58564),
          bgColor: const Color(0xFFF7E9DA),
          onTap: () => Navigator.pushNamed(context, '/program_categories'),
        ),
        _buildDashboardItem(
          context,
          title: 'Loose Diamonds',
          subtitle: 'Search loose\ndiamonds',
          icon: Icons.diamond_outlined,
          iconColor: const Color(0xFF4A90E2),
          bgColor: const Color(0xFFE0EEFE),
          onTap: () => Navigator.pushNamed(context, '/loose_diamonds_categories'),
        ),
        _buildDashboardItem(
          context,
          title: 'Custom',
          subtitle: 'Create your\nown design',
          icon: Icons.design_services_outlined,
          iconColor: const Color(0xFF8B6CB2),
          bgColor: const Color(0xFFEFDFFF),
          onTap: () {
            if (widget.onNavigate != null) {
              widget.onNavigate!(2);
            } else {
              Navigator.pushNamed(context, '/custom_design');
            }
          },
        ),
        _buildDashboardItem(
          context,
          title: 'My orders',
          subtitle: 'Track and manage\nyour orders',
          icon: Icons.shopping_bag_outlined,
          iconColor: const Color(0xFFB577A8),
          bgColor: const Color(0xFFFDE8F6),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QuotesView(type: 'my_orders'),
              ),
            );
          },
        ),
        _buildDashboardItem(
          context,
          title: 'My cart',
          subtitle: 'Manage your\nshopping cart',
          icon: Icons.shopping_cart_outlined,
          iconColor: const Color(0xFF439A86),
          bgColor: const Color(0xFFDCF3E8),
          onTap: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
        if (!_isLoadingProfile &&
            _cadGalleryName != null &&
            _cadGalleryName!.isNotEmpty &&
            _cadGalleryStatus == '1')
          _buildDashboardItem(
            context,
            title: 'My CAD',
            subtitle: 'View your\nCAD designs',
            icon: Icons.architecture_outlined,
            iconColor: const Color(0xFFC78B6C),
            bgColor: const Color(0xFFFBEADB),
            onTap: () => Navigator.pushNamed(context, '/my_cad'),
          ),
        if (!_isLoadingProfile &&
            _cadGalleryName != null &&
            _cadGalleryName!.isNotEmpty &&
            _cadGalleryStatus == '1')
          _buildDashboardItem(
            context,
            title: 'My Gallery',
            subtitle: 'View your\ngallery',
            icon: Icons.photo_library_outlined,
            iconColor: const Color(0xFF67B08B),
            bgColor: const Color(0xFFDCF3E8),
            onTap: () => Navigator.pushNamed(context, '/gallery'),
          ),
      ],
    );
  }

  Widget _buildDashboardItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required dynamic icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: icon is IconData
                      ? Icon(icon, color: iconColor, size: 24)
                      : FaIcon(icon, color: iconColor, size: 24),
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          '$badgeCount',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chevron_right, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFF7F8FA),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.headset_mic_outlined, color: Color(0xFF2C3E50), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'DiaExpressions',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'diamondexpressionsny@gmail.com',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse('mailto:diamondexpressionsny@gmail.com');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0EEFE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.email_outlined, color: Color(0xFF6B8BBE), size: 20),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse('https://wa.me/19174473233');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCF3E8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF67B08B), size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
