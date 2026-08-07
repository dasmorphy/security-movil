import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationHistoryDetailScreen extends ConsumerStatefulWidget  {
  static const name = 'notification-history-detail-screen';
  
  const NotificationHistoryDetailScreen({super.key});

  @override
  ConsumerState<NotificationHistoryDetailScreen> createState() => _NotificationHistoryDetailScreenState();
}

class _NotificationHistoryDetailScreenState extends ConsumerState<NotificationHistoryDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(getNotifications.notifier).load();
  }
  

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(getNotifications);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderOptionsProfile(headerTxt: "Notificaciones",),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      body: SafeArea(
        top: false,
        // bottom: false,
        child: 
          NotificationList(
            notifications: notifications
          ),
      ),
    );
  }
}
