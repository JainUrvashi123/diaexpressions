import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_assets.dart';
import '../core/constants/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/jewelry_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/wishlist_viewmodel.dart';
import '../viewmodels/quote_viewmodel.dart';
import '../viewmodels/notification_viewmodel.dart';
import '../core/providers/global_loader_provider.dart';
import '../core/network/dio_client.dart';
import 'home_view.dart';
import 'jewelry_view.dart';
import 'custom_design_view.dart';
import 'contact_view.dart';
import 'components/update_banner.dart';

class MainLayoutView extends StatefulWidget {
  const MainLayoutView({Key? key}) : super(key: key);

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

// class _MainLayoutViewState extends State<MainLayoutView> {
//   int _currentIndex = 0;
//
//   final List<Widget> _pages = [
//     const HomeView(),
//     const JewelryView(),
//     const Center(child: Text('Custom Design Coming Soon')),
//     const Center(child: Text('Contact Coming Soon')),
//     const Center(child: Text('Information Coming Soon')),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   void _showFilterBottomSheet(BuildContext context, JewelryViewModel vm) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setStateSync) {
//             return DraggableScrollableSheet(
//               initialChildSize: 0.8,
//               minChildSize: 0.5,
//               maxChildSize: 0.95,
//               expand: false,
//               builder: (context, scrollController) {
//                 return Column(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       decoration: BoxDecoration(
//                         border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('Filters', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
//                           TextButton(
//                             onPressed: () {
//                               vm.clearFilters();
//                               Navigator.pop(context);
//                             },
//                             child: Text('CLEAR ALL', style: GoogleFonts.poppins(color: Colors.black)),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: vm.isLoadingFilters
//                           ? const Center(child: CircularProgressIndicator())
//                           : ListView(
//                               controller: scrollController,
//                               padding: const EdgeInsets.all(16),
//                               children: [
//                                 _buildFilterSection(
//                                   title: 'CATEGORIES',
//                                   items: vm.filterData?.categories ?? [],
//                                   selectedItems: vm.selectedCategories,
//                                   onToggle: (val) {
//                                     vm.toggleCategory(val);
//                                     setStateSync(() {});
//                                   },
//                                 ),
//                                 const Divider(),
//                                 _buildFilterSection(
//                                   title: 'METAL TYPE',
//                                   items: vm.filterData?.metalTypes ?? [],
//                                   selectedItems: vm.selectedMetals,
//                                   onToggle: (val) {
//                                     vm.toggleMetal(val);
//                                     setStateSync(() {});
//                                   },
//                                 ),
//                                 const Divider(),
//                                 _buildFilterSection(
//                                   title: 'STONE SHAPE',
//                                   items: vm.filterData?.stoneShapes ?? [],
//                                   selectedItems: vm.selectedShapes,
//                                   onToggle: (val) {
//                                     vm.toggleShape(val);
//                                     setStateSync(() {});
//                                   },
//                                 ),
//                                 const SizedBox(height: 80),
//                               ],
//                             ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
//                       ),
//                       child: SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const AppColors.primaryButton,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                           ),
//                           onPressed: () {
//                             vm.applyFilters();
//                             Navigator.pop(context);
//                           },
//                           child: Text('APPLY FILTERS', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildFilterSection({
//     required String title,
//     required List<String> items,
//     required List<String> selectedItems,
//     required Function(String) onToggle,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 8,
//           runSpacing: 0,
//           children: items.map((item) {
//             final isSelected = selectedItems.contains(item);
//             return FilterChip(
//               label: Text(item, style: GoogleFonts.poppins(fontSize: 12, color: isSelected ? Colors.white : Colors.black87)),
//               selected: isSelected,
//               onSelected: (_) => onToggle(item),
//               selectedColor: const AppColors.primaryButton,
//               checkmarkColor: Colors.white,
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 2,
//         shadowColor: Colors.black12,
//         iconTheme: const IconThemeData(color: Colors.black),
//         title: Image.asset(AppAssets.logoEmail, height: 40, fit: BoxFit.contain),
//         centerTitle: true,
//         actions: [
//           if (_currentIndex == 1)
//             Consumer<JewelryViewModel>(
//               builder: (context, vm, _) {
//                 return IconButton(
//                   icon: const Icon(Icons.filter_list),
//                   onPressed: () => _showFilterBottomSheet(context, vm),
//                 );
//               },
//             ),
//           Consumer<AuthViewModel>(
//             builder: (context, authViewModel, child) {
//               final user = authViewModel.user;
//               if (user != null) {
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: PopupMenuButton<String>(
//                     offset: const Offset(0, 45),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     color: Colors.white,
//                     elevation: 4,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.person_outline, color: Colors.black87),
//                         const SizedBox(width: 4),
//                         Text(
//                           '${user.userFirstname.isNotEmpty ? user.userFirstname[0].toUpperCase() : ''}${user.userLastname.isNotEmpty ? user.userLastname[0].toUpperCase() : ''}',
//                           style: GoogleFonts.poppins(
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                           ),
//                         ),
//                         const Icon(Icons.arrow_drop_down, color: Colors.black87),
//                       ],
//                     ),
//                     onSelected: (value) async {
//                       if (value == 'logout') {
//                         await authViewModel.logout();
//                       } else if (value == 'profile') {
//                         Navigator.pushNamed(context, '/profile');
//                       }
//                     },
//                     itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//                       PopupMenuItem<String>(
//                         value: 'profile',
//                         child: Row(
//                           children: [
//                             const Icon(Icons.person_outline, size: 20, color: Colors.black54),
//                             const SizedBox(width: 12),
//                             Text(
//                               user.userFullname.isNotEmpty ? user.userFullname : '${user.userFirstname} ${user.userLastname}'.trim(),
//                               style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const PopupMenuDivider(),
//                       PopupMenuItem<String>(
//                         value: 'compare',
//                         child: Row(
//                           children: [
//                             const Icon(Icons.compare_arrows_outlined, size: 20, color: Colors.black54),
//                             const SizedBox(width: 12),
//                             Text('Compare', style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
//                           ],
//                         ),
//                       ),
//                       PopupMenuItem<String>(
//                         value: 'quotes',
//                         child: Row(
//                           children: [
//                             const Icon(Icons.format_quote_outlined, size: 20, color: Colors.black54),
//                             const SizedBox(width: 12),
//                             Text('My Quotes', style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
//                           ],
//                         ),
//                       ),
//                       const PopupMenuDivider(),
//                       PopupMenuItem<String>(
//                         value: 'logout',
//                         child: Row(
//                           children: [
//                             const Icon(Icons.logout_outlined, size: 20, color: Colors.black54),
//                             const SizedBox(width: 12),
//                             Text('Logout', style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               return IconButton(
//                 icon: const Icon(Icons.person_outline),
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/login');
//                 },
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.favorite_border_outlined),
//             onPressed: () {
//               Navigator.pushNamed(context, '/wishlist');
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.shopping_bag_outlined),
//             onPressed: () {
//               Navigator.pushNamed(context, '/cart');
//             },
//           ),
//         ],
//       ),
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: const AppColors.primaryButton,
//         unselectedItemColor: Colors.black54,
//         selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
//         unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined),
//             activeIcon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.diamond_outlined),
//             activeIcon: Icon(Icons.diamond),
//             label: 'Jewelry',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.design_services_outlined),
//             activeIcon: Icon(Icons.design_services),
//             label: 'Custom',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.contact_mail_outlined),
//             activeIcon: Icon(Icons.contact_mail),
//             label: 'Contact',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.info_outline),
//             activeIcon: Icon(Icons.info),
//             label: 'Info',
//           ),
//         ],
//       ),
//     );
//   }


class _MainLayoutViewState extends State<MainLayoutView> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _hasShownLibertyTourAd = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int) {
        setState(() {
          _currentIndex = args;
        });
      }
      final auth = Provider.of<AuthViewModel>(context, listen: false);
      final quoteVM = Provider.of<QuoteViewModel>(context, listen: false);
      final wishlistVM = Provider.of<WishlistViewModel>(context, listen: false);
      final notificationVM = Provider.of<NotificationViewModel>(context, listen: false);
      if (auth.user != null) {
        notificationVM.fetchNotifications(auth.user!.userId);
        if (auth.user!.userType == '1') {
          quoteVM.fetchAdminDesigns(auth);
        } else {
          quoteVM.fetchQuotes(auth);
          wishlistVM.fetchWishlist(auth.user!.userId);
        }
      }
      _checkForUpdate();
    });
  }

  Future<void> _checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final platform = Platform.isAndroid ? 'android' : 'ios';
      
      // Query backend check-app-version endpoint with dynamic local and platform versions
      final checkResponse = await DioClient().dio.get(
        '/m_api/check-app-version',
        data: {
          'version': currentVersion,
          'platform': platform,
        },
      );
      
      if (checkResponse.statusCode == 200 && checkResponse.data != null) {
        final checkData = checkResponse.data;
        if (checkData is Map<String, dynamic> && checkData['status'] == true) {
          final updateRequired = checkData['update_required'] == true;
          final latestVersion = checkData['latest_version'] as String?;
          final forceUpdate = checkData['force_update'] == true;
          final playstoreUrl = checkData['playstore_url'] as String?;
          final appstoreUrl = checkData['appstore_url'] as String?;
          
          if (mounted) {
            final authVM = Provider.of<AuthViewModel>(context, listen: false);
            authVM.setUpdateInfo(
              updateRequired: updateRequired,
              latestVersion: latestVersion,
              forceUpdate: forceUpdate,
              playstoreUrl: playstoreUrl,
              appstoreUrl: appstoreUrl,
            );
            
            if (updateRequired) {
              _showUpdateDialog(context);
            } else {
              _showLibertyTourAd();
            }
          }
        } else {
          if (mounted) _showLibertyTourAd();
        }
      } else {
        if (mounted) _showLibertyTourAd();
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      if (mounted) _showLibertyTourAd();
    }
  }

  void _showLibertyTourAd() {
    if (_hasShownLibertyTourAd) return;
    _hasShownLibertyTourAd = true;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 10,
          backgroundColor: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF6F0), // Cream background from flyer
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFC78B6C), width: 1.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Show the flyer image (Tappable for zoom)
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Close the small ad dialog first
                        _showZoomedImage(); // Show zoomed image modal
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Image.asset(
                              'assets/images/liberty_tour.jpeg',
                              fit: BoxFit.contain,
                            ),
                          ),
                          // "Tap to zoom" hint overlay
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.zoom_in, color: Colors.white, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Tap to Zoom',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Action Buttons Area
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Book an Appointment:',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F2C59),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0F2C59),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  onPressed: () async {
                                    final url = Uri.parse('tel:8007555768');
                                    try {
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        // Fallback directly launch
                                        await launchUrl(url, mode: LaunchMode.externalApplication);
                                      }
                                    } catch (e) {
                                      debugPrint('Error launching dialer: $e');
                                    }
                                  },
                                  icon: const Icon(Icons.phone, size: 16, color: Colors.white),
                                  label: Text(
                                    'CALL NOW',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFC78B6C),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  onPressed: () async {
                                    final url = Uri.parse('mailto:sales@diaexpressions.com?subject=Liberty%20Tour%20Appointment%20Request');
                                    try {
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        // Fallback directly launch
                                        await launchUrl(url, mode: LaunchMode.externalApplication);
                                      }
                                    } catch (e) {
                                      debugPrint('Error launching email: $e');
                                    }
                                  },
                                  icon: const Icon(Icons.email_outlined, size: 16, color: Colors.white),
                                  label: Text(
                                    'EMAIL US',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Close Icon Top-Right
              Positioned(
                right: -8,
                top: -8,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF0F2C59), size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showZoomedImage() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          insetPadding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Zoomable Image using InteractiveViewer
              Positioned.fill(
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 1.0,
                  maxScale: 5.0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/liberty_tour.jpeg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              
              // Close button overlay
              Positioned(
                top: 40,
                right: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              
              // Helper text at the bottom
              Positioned(
                bottom: 40,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Pinch to zoom / Pan to move',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final forceUpdate = auth.forceUpdate;
    final latestVersion = auth.latestVersion ?? '';

    showDialog(
      context: context,
      barrierDismissible: !forceUpdate,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => !forceUpdate,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                const Icon(Icons.system_update_outlined, color: AppColors.primaryButton, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'App Update Available',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A new version ${latestVersion.isNotEmpty ? '($latestVersion) ' : ''}of DiaExpressions is available. Update now to access the latest features and improvements.',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            actionsAlignment: forceUpdate ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            actions: [
              if (!forceUpdate)
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'LATER',
                    style: GoogleFonts.poppins(color: Colors.grey[600], fontWeight: FontWeight.w600),
                  ),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryButton,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onPressed: () async {
                  final isAndroid = Platform.isAndroid;
                  String? urlString;
                  if (isAndroid) {
                    urlString = auth.playstoreUrl ?? 'https://play.google.com/store/apps/details?id=com.diaexp.app';
                  } else {
                    urlString = auth.appstoreUrl ?? 'https://apps.apple.com/in/app/diaexpressions/id1509711851';
                  }
                  final url = Uri.parse(urlString);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  'UPDATE',
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);
    final user = auth.user;
    final isAdmin = user?.userType == '1';

    // Clamp _currentIndex to prevent index out of range when switching layout modes
    final int maxIndex = isAdmin ? 2 : 3;
    if (_currentIndex > maxIndex) {
      _currentIndex = maxIndex;
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawerEnableOpenDragGesture: _currentIndex == 0,
      appBar: AppBar(
        leading: _currentIndex == 0
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _currentIndex = 0),
              ),
        backgroundColor: Colors.white,
        elevation: _currentIndex == 0 ? 0 : null,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: _currentIndex == 0
            ? Text(
                'Dashboard',
                style: GoogleFonts.poppins(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w400),
              )
            : Image.asset(AppAssets.logoEmail, height: 35, fit: BoxFit.contain),
        actions: [
          if (_currentIndex == 0) ...[
            Consumer<NotificationViewModel>(
              builder: (context, notificationVM, _) {
                final count = notificationVM.notificationCount;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, size: 22),
                      onPressed: () {
                        Navigator.pushNamed(context, '/notifications');
                      },
                    ),
                    if (count > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Center(
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            _buildProfileButton(context),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.search, size: 22),
              onPressed: () => Navigator.pushNamed(context, '/search'),
            ),
            // Filter only shows on Jewelry Tab
            if (_currentIndex == 1)
              Consumer<JewelryViewModel>(
                builder: (context, vm, _) => IconButton(
                  icon: const Icon(Icons.tune_outlined, size: 22),
                  onPressed: () => _showFilterBottomSheet(context, vm),
                ),
              ),

            Consumer<CartViewModel>(
              builder: (context, cart, _) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined, size: 22),
                      onPressed: () => Navigator.pushNamed(context, '/cart'),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cart.totalItemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            _buildProfileButton(context),
          ],
        ],
      ),
      drawer: _buildDrawer(context),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeView(onNavigate: (index) {
            if (isAdmin) {
              if (index == 2) return; // Custom is hidden/disabled for admin
              if (index == 3) {
                setState(() => _currentIndex = 2);
                return;
              }
            }
            setState(() => _currentIndex = index);
          }),
          const JewelryView(showAppBar: false),
          if (!isAdmin) const CustomDesignView(showAppBar: false),
          const ContactView(),
        ],
      ),
      bottomNavigationBar: isAdmin
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.primaryButton,
              unselectedItemColor: Colors.black45,
              showUnselectedLabels: true,
              selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.diamond_outlined), label: 'Jewelry'),
                BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_outlined), label: 'Custom'),
                BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: 'Contact'),
              ],
            ),
    );
  }


  Widget _buildProfileButton(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, auth, _) {
        final user = auth.user;
        if (user != null) {
          final firstLetter = user.userFirstname.isNotEmpty 
              ? user.userFirstname[0].toUpperCase() 
              : 'U';
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryButton.withOpacity(0.1),
                child: Text(
                  firstLetter,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryButton,
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }


  void _showFilterBottomSheet(BuildContext context, JewelryViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return _FilterBottomSheetContent(vm: vm);
      },
    );
  }



  void _showDeleteAccountDialog(BuildContext context, AuthViewModel authViewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Delete Account',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete your account?',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text(
                'This action is permanent and cannot be undone. All your data will be permanently removed.',
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'CANCEL',
                style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                Navigator.pop(context);
                final success = await authViewModel.deleteAccount();
                if (success) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Account deleted successfully')),
                    );
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(authViewModel.errorMessage ?? 'Failed to delete account')),
                    );
                  }
                }
              },
              child: Text(
                'DELETE',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, AuthViewModel authViewModel) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to log out of your account?',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'CANCEL',
                style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButton,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
                final wishlistViewModel = Provider.of<WishlistViewModel>(context, listen: false);
                final quoteViewModel = Provider.of<QuoteViewModel>(context, listen: false);
                final globalLoader = Provider.of<GlobalLoaderProvider>(context, listen: false);

                Navigator.pop(dialogContext);
                globalLoader.show();
                await authViewModel.logout();

                cartViewModel.clearCart();
                wishlistViewModel.clearWishlist();
                quoteViewModel.clearQuotes();
                globalLoader.hide();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out successfully')),
                  );
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: Text(
                'LOGOUT',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }



  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: Consumer<AuthViewModel>(
        builder: (context, auth, _) {
          final user = auth.user;
          final isAdmin = user?.userType == '1';

          final userName = user != null 
              ? (user.userFullname.isNotEmpty 
                  ? user.userFullname 
                  : '${user.userFirstname} ${user.userLastname}'.trim()) 
              : 'User';
              
          final firstLetter = user != null 
              ? (user.userFirstname.isNotEmpty ? user.userFirstname[0].toUpperCase() : 'U') 
              : 'U';

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 30, left: 24, right: 24),
                decoration: const BoxDecoration(
                  color: AppColors.primaryButton,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: Text(
                          firstLetter,
                          style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryButton),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, 
                        fontSize: 18, 
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.userEmail ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 13, 
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Drawer Items
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                        const UpdateBanner(),
                        _drawerTile(Icons.person_outline_rounded, 'My Profile', () => Navigator.pushNamed(context, '/profile')),
                        if (!isAdmin)
                          Consumer<WishlistViewModel>(
                            builder: (context, wishlistVM, _) {
                              final count = wishlistVM.wishlistData?.allItems.length ?? 0;
                              return _drawerTile(
                                Icons.favorite_border_rounded,
                                'Wishlist',
                                () => Navigator.pushNamed(context, '/wishlist'),
                                trailing: count > 0
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '$count',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : null,
                              );
                            },
                          ),
                        // if (!isAdmin) _drawerTile(Icons.compare_arrows_rounded, 'Compare Products', () => Navigator.pushNamed(context, '/compare')),
                        if (!isAdmin)
                          Consumer<QuoteViewModel>(
                            builder: (context, quoteVM, _) {
                              final count = quoteVM.unreadQuotesCount;
                              return _drawerTile(
                                Icons.format_quote_rounded,
                                'My Quotes',
                                () => Navigator.pushNamed(context, '/quotes'),
                                trailing: count > 0
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '$count',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : null,
                              );
                            },
                          ),
                        if (isAdmin)
                          Consumer<QuoteViewModel>(
                            builder: (context, quoteVM, _) {
                              final count = quoteVM.unreadAdminEnquiriesCount;
                              return _drawerTile(
                                Icons.admin_panel_settings_rounded,
                                'Design Enquiries',
                                () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/admin_enquiries');
                                },
                                trailing: count > 0
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '$count',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : null,
                              );
                            },
                          ),
                        _drawerTile(Icons.delete_forever_outlined, 'Delete Account', () {
                          Navigator.pop(context);
                          _showDeleteAccountDialog(this.context, auth);
                        }),

        
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Divider(color: Colors.grey[200], thickness: 1),
                      ),
                      
                      _drawerTile(Icons.help_outline_rounded, 'FAQ', () {
                        Navigator.pushNamed(context, '/faq');
                      }),
                      _drawerTile(Icons.policy_outlined, 'Terms & Conditions', () => Navigator.pushNamed(context, '/terms_conditions')),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),


              if (user != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        offset: const Offset(0, -4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _showLogoutDialog(this.context, auth);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Logout', 
                            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title, VoidCallback onTap, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryButton.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryButton, size: 20),
        ),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: Colors.black26, size: 20),
        onTap: onTap,
        dense: true,
        hoverColor: Colors.grey[50],
      ),
    );
  }
}

class CustomRangeThumbShape extends RangeSliderThumbShape {
  final double enabledThumbRadius;
  final double innerRadius;

  const CustomRangeThumbShape({
    this.enabledThumbRadius = 10.0,
    this.innerRadius = 4.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = true,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb thumb = Thumb.start,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    if (isPressed == true) {
      final Paint shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(center, enabledThumbRadius + 2, shadowPaint);
    }

    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, enabledThumbRadius, whitePaint);

    final Paint borderPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, enabledThumbRadius, borderPaint);

    final Paint innerPaint = Paint()
      ..color = sliderTheme.activeTrackColor ?? const Color(0xFFEBA553)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, innerPaint);
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FilterBottomSheetContent extends StatefulWidget {
  final JewelryViewModel vm;

  const _FilterBottomSheetContent({
    Key? key,
    required this.vm,
  }) : super(key: key);

  @override
  State<_FilterBottomSheetContent> createState() => _FilterBottomSheetContentState();
}

class _FilterBottomSheetContentState extends State<_FilterBottomSheetContent> {
  late double localMin;
  late double localMax;
  late TextEditingController minController;
  late TextEditingController maxController;

  @override
  void initState() {
    super.initState();
    localMin = widget.vm.minPrice;
    localMax = widget.vm.maxPrice;
    minController = TextEditingController(text: _formatInputValue(localMin));
    maxController = TextEditingController(text: _formatInputValue(localMax));
  }

  @override
  void dispose() {
    minController.dispose();
    maxController.dispose();
    super.dispose();
  }

  double _priceToSliderValue(double price) {
    if (price <= 0.0) return 0.0;
    if (price >= 999999999999.0) return 100.0;
    
    final p = price.clamp(1.0, 150000000.0);
    final logVal = math.log(p);
    final logMax = math.log(150000000.0);
    return (logVal / logMax) * 100.0;
  }

  double _sliderValueToPrice(double v) {
    if (v <= 0.0) return 0.0;
    if (v >= 100.0) return 999999999999.0;
    
    final logMax = math.log(150000000.0);
    final p = math.exp((v / 100.0) * logMax);
    return p;
  }

  String _formatSliderValue(double val) {
    if (val >= 999999999999.0) {
      return '150 000 000';
    }
    return val.toInt().toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }

  String _formatInputValue(double val) {
    if (val >= 999999999999.0) {
      return '150,000,000';
    }
    final formatted = val.toInt().toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return formatted;
  }

  Widget _buildPriceRangeSection({
    required double currentMin,
    required double currentMax,
    required TextEditingController minController,
    required TextEditingController maxController,
    required Function(double, double) onRangeChanged,
    required StateSetter setStateSync,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double trackWidth = width - 32.0;
        final double leftThumbPct = _priceToSliderValue(currentMin <= currentMax ? currentMin : currentMax) / 100.0;
        final double rightThumbPct = _priceToSliderValue(currentMin <= currentMax ? currentMax : currentMin) / 100.0;
        
        final double leftBubbleX = 16.0 + leftThumbPct * trackWidth;
        final double rightBubbleX = 16.0 + rightThumbPct * trackWidth;
        
        double leftOffset = 0.0;
        double rightOffset = 0.0;
        if ((rightBubbleX - leftBubbleX) < 60.0) {
          final overlap = 60.0 - (rightBubbleX - leftBubbleX);
          leftOffset = -overlap / 2;
          rightOffset = overlap / 2;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PRICE RANGE',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 28,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: (leftBubbleX + leftOffset - 35).clamp(0.0, width - 70.0),
                    child: SizedBox(
                      width: 70,
                      child: Center(
                        child: _buildBubble(
                          _formatSliderValue(currentMin <= currentMax ? currentMin : currentMax),
                          isDark: true,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: (rightBubbleX + rightOffset - 35).clamp(0.0, width - 70.0),
                    child: SizedBox(
                      width: 70,
                      child: Center(
                        child: _buildBubble(
                          _formatSliderValue(currentMin <= currentMax ? currentMax : currentMin),
                          isDark: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.primaryButton,
                inactiveTrackColor: Colors.grey[200],
                thumbColor: Colors.white,
                activeTickMarkColor: Colors.transparent,
                inactiveTickMarkColor: Colors.transparent,
                overlayColor: AppColors.primaryButton.withOpacity(0.12),
                showValueIndicator: ShowValueIndicator.never,
                rangeThumbShape: const CustomRangeThumbShape(
                  enabledThumbRadius: 12,
                  innerRadius: 5,
                ),
              ),
              child: RangeSlider(
                values: RangeValues(
                  _priceToSliderValue(currentMin <= currentMax ? currentMin : currentMax),
                  _priceToSliderValue(currentMin <= currentMax ? currentMax : currentMin),
                ),
                min: 0.0,
                max: 100.0,
                onChanged: (RangeValues values) {
                  double newMin = _sliderValueToPrice(values.start);
                  double newMax = _sliderValueToPrice(values.end);
                  
                  double roundPrice(double val) {
                    if (val <= 0.0) return 0.0;
                    if (val >= 150000000.0) return 999999999999.0;
                    final log10 = math.log(val) / math.log(10);
                    final power = log10.floor();
                    final step = math.pow(10, math.max(0, power - 1)).toDouble();
                    return (val / step).round() * step;
                  }
                  
                  newMin = roundPrice(newMin);
                  newMax = roundPrice(newMax);
                  
                  onRangeChanged(newMin, newMax);
                  minController.text = _formatInputValue(newMin);
                  maxController.text = _formatInputValue(newMax);
                  setStateSync(() {});
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextFormField(
                      controller: minController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        prefixStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                      style: GoogleFonts.poppins(fontSize: 14),
                      onChanged: (val) {
                        final cleanText = val.replaceAll('\$', '').replaceAll('+', '').replaceAll(',', '').replaceAll(' ', '');
                        final parsed = double.tryParse(cleanText);
                        if (parsed != null && parsed >= 0.0 && parsed <= 999999999999.0) {
                          onRangeChanged(parsed, currentMax);
                          setStateSync(() {});
                        }
                      },
                      onEditingComplete: () {
                        final cleanText = minController.text.replaceAll('\$', '').replaceAll('+', '').replaceAll(',', '').replaceAll(' ', '');
                        final parsed = double.tryParse(cleanText) ?? 0.0;
                        final clamped = parsed.clamp(0.0, 999999999999.0);
                        if (clamped > currentMax) {
                          onRangeChanged(currentMax, clamped);
                          minController.text = _formatInputValue(currentMax);
                          maxController.text = _formatInputValue(clamped);
                        } else {
                          onRangeChanged(clamped, currentMax);
                          minController.text = _formatInputValue(clamped);
                        }
                        FocusScope.of(context).unfocus();
                        setStateSync(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextFormField(
                      controller: maxController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        prefixStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                      style: GoogleFonts.poppins(fontSize: 14),
                      onChanged: (val) {
                        final cleanText = val.replaceAll('\$', '').replaceAll('+', '').replaceAll(',', '').replaceAll(' ', '');
                        final parsed = double.tryParse(cleanText);
                        if (parsed != null && parsed >= 0.0 && parsed <= 999999999999.0) {
                          onRangeChanged(currentMin, parsed);
                          setStateSync(() {});
                        }
                      },
                      onEditingComplete: () {
                        final cleanText = maxController.text.replaceAll('\$', '').replaceAll('+', '').replaceAll(',', '').replaceAll(' ', '');
                        final parsed = double.tryParse(cleanText) ?? 999999999999.0;
                        final clamped = parsed.clamp(0.0, 999999999999.0);
                        if (currentMin > clamped) {
                          onRangeChanged(clamped, currentMin);
                          minController.text = _formatInputValue(clamped);
                          maxController.text = _formatInputValue(currentMin);
                        } else {
                          onRangeChanged(currentMin, clamped);
                          maxController.text = _formatInputValue(clamped);
                        }
                        FocusScope.of(context).unfocus();
                        setStateSync(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBubble(String text, {required bool isDark, bool showArrow = true}) {
    final color = isDark ? const Color(0xFF9E9E9E) : const Color(0xFFECEFF1);
    final textColor = isDark ? Colors.white : const Color(0xFF546E7A);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        if (showArrow)
          CustomPaint(
            size: const Size(6, 3),
            painter: TrianglePainter(color: color),
          ),
      ],
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<String> items,
    required List<String> selectedItems,
    required Function(String) onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: items.map((item) {
            final isSelected = selectedItems.contains(item);
            return FilterChip(
              label: Text(
                item,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onToggle(item),
              selectedColor: AppColors.primaryButton,
              backgroundColor: Colors.grey[50],
              checkmarkColor: Colors.white,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? Colors.transparent : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              elevation: 0,
              pressElevation: 0,
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.vm;
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      vm.clearFilters();
                      localMin = 0.0;
                      localMax = 999999999999.0;
                      minController.text = _formatInputValue(localMin);
                      maxController.text = _formatInputValue(localMax);
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Text('CLEAR ALL', style: GoogleFonts.poppins(color: Colors.black)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: vm.isLoadingFilters
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  _buildPriceRangeSection(
                    currentMin: localMin,
                    currentMax: localMax,
                    minController: minController,
                    maxController: maxController,
                    onRangeChanged: (min, max) {
                      localMin = min;
                      localMax = max;
                      vm.updatePriceRange(min, max);
                    },
                    setStateSync: setState,
                  ),
                  const Divider(),
                  _buildFilterSection(
                    title: 'CATEGORIES',
                    items: vm.filterData?.categories ?? [],
                    selectedItems: vm.selectedCategories,
                    onToggle: (val) {
                      vm.toggleCategory(val);
                      setState(() {});
                    },
                  ),
                  const Divider(),
                  _buildFilterSection(
                    title: 'METAL TYPE',
                    items: vm.filterData?.metalTypes ?? [],
                    selectedItems: vm.selectedMetals,
                    onToggle: (val) {
                      vm.toggleMetal(val);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryButton,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    final minText = minController.text.replaceAll('\$', '').replaceAll('+', '').replaceAll(',', '').replaceAll(' ', '');
                    final maxText = maxController.text.replaceAll('\$', '').replaceAll('+', '').replaceAll(',', '').replaceAll(' ', '');
                    double minVal = double.tryParse(minText) ?? 0.0;
                    double maxVal = double.tryParse(maxText) ?? 999999999999.0;
                    minVal = minVal.clamp(0.0, 999999999999.0);
                    maxVal = maxVal.clamp(0.0, 999999999999.0);
                    
                    if (minVal > maxVal) {
                      final temp = minVal;
                      minVal = maxVal;
                      maxVal = temp;
                    }
                    
                    vm.updatePriceRange(minVal, maxVal);
                    vm.applyFilters();
                    Navigator.pop(context);
                  },
                  child: Text('APPLY FILTERS', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}