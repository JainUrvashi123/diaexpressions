import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/jewelry_viewmodel.dart';
import '../viewmodels/wishlist_viewmodel.dart';
import 'components/jewelry_item_card.dart';


class JewelryView extends StatefulWidget {
  final bool showAppBar;
  const JewelryView({Key? key, this.showAppBar = true}) : super(key: key);

  @override
  State<JewelryView> createState() => _JewelryViewState();
}

class _JewelryViewState extends State<JewelryView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<JewelryViewModel>(context, listen: false);
      if (vm.jewelryList.isEmpty && !vm.isLoadingJewelry) {
        vm.fetchJewelry(reset: true);
      }
      
      final authVm = Provider.of<AuthViewModel>(context, listen: false);
      if (authVm.user != null) {
        final wishlistVm = Provider.of<WishlistViewModel>(context, listen: false);
        wishlistVm.fetchWishlist(authVm.user!.userId);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final vm = Provider.of<JewelryViewModel>(context, listen: false);
      vm.fetchJewelry();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F5),
      appBar: widget.showAppBar ? AppBar(
        title: Text('Jewelry', style: GoogleFonts.poppins(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ) : null,
      body: Consumer<JewelryViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoadingJewelry && vm.jewelryList.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryButton));
          }
          if (vm.error != null && vm.jewelryList.isEmpty) {
            return Center(child: Text(vm.error!, style: GoogleFonts.poppins(color: Colors.red)));
          }
          if (vm.jewelryList.isEmpty) {
            return Center(child: Text("No jewelry found.", style: GoogleFonts.poppins()));
          }

          return RefreshIndicator(
            onRefresh: () => vm.fetchJewelry(reset: true),
            color:  AppColors.primaryButton,
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding,
                vertical: 16,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65, // Adjust based on content
              ),
              itemCount: vm.jewelryList.length + (vm.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == vm.jewelryList.length) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryButton));
                }
                final item = vm.jewelryList[index];
                return JewelryItemCard(item: item);
              },
            ),
          );
        },
      ),
    );
  }
}


