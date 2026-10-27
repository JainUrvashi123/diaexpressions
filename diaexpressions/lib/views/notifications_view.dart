import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/notification_model.dart';
import '../models/quote_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/notification_viewmodel.dart';
import 'quote_detail_view.dart';
import 'admin_enquiry_detail_view.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthViewModel>(context, listen: false);
      if (auth.user != null) {
        Provider.of<NotificationViewModel>(context, listen: false)
            .fetchNotifications(auth.user!.userId);
      }
    });
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final month = months[dt.month - 1];
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      final minute = dt.minute.toString().padLeft(2, '0');
      return '$month ${dt.day}, ${dt.year} at $hour:$minute $ampm';
    } catch (_) {
      return dateStr;
    }
  }

  IconData _getNotificationIcon(NotificationItem item) {
    final titleLower = item.title.toLowerCase();
    final msgLower = item.message.toLowerCase();

    if (titleLower.contains('reply') || msgLower.contains('replied')) {
      return Icons.forum_outlined;
    } else if (titleLower.contains('request') || msgLower.contains('submitted')) {
      return Icons.assignment_turned_in_outlined;
    } else if (titleLower.contains('status') || msgLower.contains('status')) {
      return Icons.info_outline;
    }
    return Icons.notifications_none_rounded;
  }

  Color _getIconColor(NotificationItem item) {
    final titleLower = item.title.toLowerCase();
    final msgLower = item.message.toLowerCase();

    if (titleLower.contains('reply') || msgLower.contains('replied')) {
      return const Color(0xFF6B8BBE); // Cool blue
    } else if (titleLower.contains('request') || msgLower.contains('submitted')) {
      return const Color(0xFF67B08B); // Emerald green
    } else if (titleLower.contains('status') || msgLower.contains('status')) {
      return const Color(0xFFC78B6C); // Premium peach
    }
    return Colors.grey;
  }

  Color _getIconBgColor(NotificationItem item) {
    final color = _getIconColor(item);
    return color.withOpacity(0.1);
  }

  void _onNotificationTap(NotificationItem item) {
    Provider.of<NotificationViewModel>(context, listen: false).markAsRead(item.notificationId);

    final designId = item.designId;
    if (designId == null || designId.isEmpty) return;

    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final user = authVM.user;
    if (user == null) return;

    final isAdmin = user.userType == '1';
    final quote = QuoteModel.dummy(designId);

    if (isAdmin) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AdminEnquiryDetailView(quote: quote),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => QuoteDetailView(quote: quote),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);
    final userId = auth.user?.userId ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F5),
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: Consumer<NotificationViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryButton,
              ),
            );
          }

          if (vm.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      vm.errorMessage!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryButton,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => vm.fetchNotifications(userId),
                      child: Text('Retry', style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          final list = vm.notifications;

          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryButton.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.primaryButton,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You will see design replies and order status updates here.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primaryButton,
            onRefresh: () => vm.fetchNotifications(userId),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                final isUnread = vm.isNotificationUnread(item);
                final hasDetail = item.designId != null && item.designId!.isNotEmpty;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isUnread ? const Color(0xFFFDF7F2) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isUnread
                          ? AppColors.primaryButton.withOpacity(0.15)
                          : Colors.grey.shade100,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isUnread ? 0.02 : 0.01),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: hasDetail ? () => _onNotificationTap(item) : null,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Notification Icon
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _getIconBgColor(item),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getNotificationIcon(item),
                                color: _getIconColor(item),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Text Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      if (isUnread)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primaryButton,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.message,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _formatDate(item.createDate),
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
