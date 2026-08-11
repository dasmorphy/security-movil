import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class NotificationHistoryDetailScreen extends ConsumerStatefulWidget {
  static const name = 'notification-history-detail-screen';

  final int historyId;

  const NotificationHistoryDetailScreen({super.key, required this.historyId});

  @override
  ConsumerState<NotificationHistoryDetailScreen> createState() =>
      _NotificationHistoryDetailScreenState();
}

class _NotificationHistoryDetailScreenState
    extends ConsumerState<NotificationHistoryDetailScreen> {
  bool _isInitializing = true;

  final TextEditingController commentaryCtrl = TextEditingController();
  final FocusNode commentaryFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await ref
            .read(getHistoryStatusProject.notifier)
            .load(filters: {"id_history": widget.historyId});
      } finally {
        if (!mounted) return;

        setState(() {
          _isInitializing = false;
        });
      }
    });
  }

  @override
  void dispose() {
    commentaryCtrl.dispose();
    commentaryFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyStatus = ref.watch(getHistoryStatusProject);
    final theme = Theme.of(context);

    final history = historyStatus.isNotEmpty ? historyStatus.first : null;
    final task = history?.task;
    final taskData = task == null
        ? null
        : TechTaskHeader(
            client: task.client,
            codeTask: task.code,
            location: task.location,
            createdBy: task.createdBy,
            cliendId: task.clientId,
            locationId: task.locationId,
            taskId: task.idTask,
          );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderOptionsProfile(headerTxt: ""),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 23, 24, 28),

      body: SafeArea(
        top: false,
        child: _isInitializing
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 280,
                      child: Text(
                        'Cargando notificación...',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
              )
            : Card(
                color: const Color.fromARGB(255, 23, 24, 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 20,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (taskData != null)
                          RecordTechnicalHeader(taskData: taskData),
                        
                        const SizedBox(height: 16,),
                        CommentaryReception(
                          enabled: false,
                          controller: commentaryCtrl
                            ..text = history?.commentary ?? '',
                          focusNode: commentaryFocus,
                          label: 'Comentarios',
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
