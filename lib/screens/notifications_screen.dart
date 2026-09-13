import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';
import '../services/session.dart';
import '../widgets/empty_state.dart';
import '../services/language_service.dart';
import '../data/product_images.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final result = await NotificationService.getNotifications(Session.userId!);
    notifications = result.map((e) => NotificationModel.fromJson(e)).toList();
    setState(() => isLoading = false);
    NotificationService.markAllRead(Session.userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LanguageService.t("notifications_title"))),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? EmptyState(icon: Icons.notifications_none_outlined, message: LanguageService.t("no_notifications_yet"))
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final n = notifications[index];
                    final displayMessage = LanguageService.translateNotification(
                      n.message,
                      LanguageService.currentLang,
                      (label) => getLocalizedProductNameByLabel(label, LanguageService.currentLang),
                    );
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: n.isRead ? null : Colors.green.withOpacity(0.08),
                      child: ListTile(
                        leading: Icon(Icons.notifications_outlined, color: n.isRead ? Colors.grey : Colors.green),
                        title: Text(displayMessage),
                        subtitle: Text(n.createdAt),
                      ),
                    );
                  },
                ),
    );
  }
}