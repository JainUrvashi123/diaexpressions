import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../models/cart_model.dart';
import '../core/network/dio_client.dart';
import 'jewelry_detail_view.dart';
import 'components/custom_text_field.dart';
import 'email_success_view.dart';
import '../core/utils/price_formatter.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartViewModel>(context, listen: false).fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const CartViewContent();
  }
}

class CartViewContent extends StatelessWidget {
  const CartViewContent({super.key});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F5),
      appBar: AppBar(
        title: const Text('Cart Details'),
      ),
      body: Consumer<CartViewModel>(
        builder: (context, viewModel, child) {
          // Initial Full Screen Loader
          if (viewModel.isLoading && viewModel.cartItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error State
          if (viewModel.error != null && viewModel.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(viewModel.error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.fetchCart(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Empty State
          if (viewModel.cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          return Stack(
            children: [
              // Main Content
              RefreshIndicator(
                onRefresh: () => viewModel.fetchCart(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                            onPressed: () => _confirmRemoveAll(context, viewModel),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryButton,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text('Remove All'),
                          ),
                        ),
                        const SizedBox(height: 16),

                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.cartItems.length,
                          separatorBuilder: (context, index) => const Divider(height: 32),
                          itemBuilder: (context, index) {
                            return _buildCartItemCard(context, viewModel.cartItems[index], viewModel);
                          },
                        ),

                        const SizedBox(height: 32),
                        const Divider(color: Colors.grey, thickness: 1),
                        const SizedBox(height: 32),

                        const Center(
                          child: Text(
                            'Cart totals',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
                              children: [
                                const TextSpan(text: 'Total to pay: '),
                                TextSpan(
                                  text: PriceFormatter.formatWithCurrency(viewModel.totalPrice),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Taxes and shipping calculated at checkout',
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ElevatedButton(
                        //   onPressed: () {}, // Checkout Logic
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: const Color(0xFFECA34F),
                        //     foregroundColor: Colors.white,
                        //     padding: const EdgeInsets.symmetric(vertical: 16),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(4),
                        //     ),
                        //   ),
                        //   child: const Text(
                        //     'Email Cart',
                        //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        //   ),
                        // ),

                        // Inside CartViewContent's build method, update the ElevatedButton:

                        ElevatedButton(
                          onPressed: () => _showEmailDialog(context, viewModel),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryButton,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Email Cart',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              // Global Overlay Progress Bar
              if (viewModel.isUpdating)
                Container(
                  color: Colors.black.withOpacity(0.1), // Slight dimming
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFECA34F)),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem item, CartViewModel viewModel) {
    int quantity = int.tryParse(item.quantity) ?? 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: item.image.isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: DioClient.getFullImageUrl(item.image),
              fit: BoxFit.contain,
              memCacheWidth: 200,
              filterQuality: FilterQuality.low,
              placeholder: (context, url) => const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFECA34F),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.image_not_supported,
                color: Colors.grey,
              ),
            ),
          )
              : const Icon(Icons.image, color: Colors.grey),
        ),
        const SizedBox(width: 16),

        // Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.stockId,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                PriceFormatter.formatWithCurrency(item.price),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),

              // Quantity controls
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (quantity > 1) {
                              viewModel.updateQuantity(item, quantity - 1);
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            child: Text('-', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey.shade300,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Text('$quantity', style: const TextStyle(fontSize: 14)),
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey.shade300,
                        ),
                        InkWell(
                          onTap: () {
                            viewModel.updateQuantity(item, quantity + 1);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            child: Text('+', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Total Price
              Text(
                'Total: ${PriceFormatter.formatWithCurrency(item.totalPrice)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),

        // Actions
        Column(
          children: [
            InkWell(
              onTap: () {
                 if (item.productType == 'jewelry') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JewelryDetailView(jewelryId: item.productId),
                      ),
                    );
                 }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFECA34F),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.remove_red_eye, color: Colors.white, size: 16),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _confirmRemove(context, viewModel, item),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFECA34F),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ],
        )
      ],
    );
  }

  void _showEmailDialog(BuildContext context, CartViewModel viewModel) async {
    final _formKey = GlobalKey<FormState>();

    // Get current user data
    final user = await viewModel.getUserData();
    if (user == null) {
      if (context.mounted) {
        _showToast(context, 'User details not found. Please log in.');
      }
      return;
    }

    final name = user.userFullname.isNotEmpty
        ? user.userFullname
        : '${user.userFirstname} ${user.userLastname}'.trim();
    final email = user.userEmail;
    final mobile = user.userMobile;

    final messageController = TextEditingController(text: "Send my cart details");

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Send Cart To Email',
                        style: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(dialogContext),
                      )
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 15),

                  // Comment Field
                  _buildPopupField(
                    "Comment :",
                    "Enter your message/comment here",
                    messageController,
                    null,
                    maxLines: 4,
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(dialogContext);
                            final success = await viewModel.sendEmailCart(
                              name: name.isNotEmpty ? name : "User",
                              email: email,
                              mobile: mobile,
                              message: messageController.text.trim(),
                            );

                            if (success && context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EmailSuccessView(),
                                ),
                              );
                              viewModel.fetchCart();
                            }
                          }
                        },
                        icon: const Icon(Icons.send, size: 16),
                        label: const Text("Send"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFECA34F),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Updated Helper with readOnly support
  Widget _buildPopupField(
      String label,
      String hint,
      TextEditingController controller,
      String? Function(String?)? validator,
      {int maxLines = 1, bool readOnly = false}
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: controller,
            maxLines: maxLines,
            validator: validator,
            readOnly: readOnly,
            hintText: hint,
          ),
        ],
      ),
    );
  }

// Helper for UI alignment like in the screenshot
//   Widget _buildPopupField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 80,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 12.0),
//               child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
//             ),
//           ),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               maxLines: maxLines,
//               decoration: InputDecoration(
//                 hintText: hint,
//                 hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                 enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
//                 focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFECA34F))),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

  void _showToast(BuildContext context, String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: isError ? Colors.red : Colors.green),
    );
  }

  void _confirmRemove(BuildContext context, CartViewModel viewModel, CartItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: const Text('Are you sure you want to remove this item from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await viewModel.removeFromCart(item.cartId, item.productType);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item removed from cart')),
                );
              }
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmRemoveAll(BuildContext context, CartViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove All Items'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await viewModel.removeAll();
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All items removed from cart')),
                );
              }
            },
            child: const Text('Remove All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
