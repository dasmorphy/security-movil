import 'package:flutter/material.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PushNotificationsScreen extends ConsumerStatefulWidget  {
  static const name = 'push-notifications-screen';
  
  const PushNotificationsScreen({super.key});

  @override
  ConsumerState<PushNotificationsScreen> createState() => _PushNotificationsScreenState();
}

class _PushNotificationsScreenState extends ConsumerState<PushNotificationsScreen> {
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
