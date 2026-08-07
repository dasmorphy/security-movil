import 'package:flutter/material.dart';
import 'package:zentinel/config/utils/helper.dart';
import 'package:zentinel/domain/entities/notification_push.dart';

class _Palette {
  static const background = Color(0xFF18191A);
  static const itemBg = Color(0xFF242526);
  static const itemUnreadBg = Color(0xFF263951);
  static const border = Color(0xFF3A3B3C);
  static const textPrimary = Color(0xFFE4E6EB);
  static const textSecondary = Color(0xFFB0B3B8);
  static const deleteBg = Color(0xFFF16A63);
  static const deleteFg = Color(0xFF3A1210);
}
class NotificationStyle {
  final Color color;
  final IconData icon;

  const NotificationStyle({
    required this.color,
    required this.icon,
  });
}

class NotificationList extends StatefulWidget {
  /// URL GET que retorna un array de notificaciones (o {"data": [...]}).
  final String? apiUrl;

  /// Alternativa a [apiUrl]: notificaciones ya cargadas por el padre.
  final List<NotificationPush> notifications;

  /// URL para el DELETE al backend. Usa "{id}" como marcador, ej:
  /// "https://tu-api.com/notifications/{id}"
  final String Function(String id)? deleteUrlBuilder;

  /// Callback adicional (o alternativo) que se dispara al eliminar.
  final void Function(String id)? onDelete;

  /// Mensaje cuando no hay notificaciones.
  final String emptyMessage;

  const NotificationList({
    super.key,
    this.apiUrl,
    required this.notifications,
    this.deleteUrlBuilder,
    this.onDelete,
    this.emptyMessage = 'No tienes notificaciones.',
  });

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<NotificationPush> get _items => widget.notifications;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NotificationList old) {
    super.didUpdateWidget(old);
  }

  Future<void> _handleDelete(NotificationPush item) async {
    if (widget.deleteUrlBuilder != null) {
      try {
        // await http.delete(Uri.parse(widget.deleteUrlBuilder!(item.id)));
      } catch (_) {
        // Si el borrado remoto falla igual quitamos el item localmente;
        // ajusta este comportamiento segun lo que necesite tu app.
      }
    }
    widget.onDelete?.call(item.idNotification);
    setState(() => _items.removeWhere((n) => n.idNotification == item.idNotification));
  }

  // Map<String, List<NotificationPush>> _grouped() {
  //   final map = <String, List<NotificationPush>>{};
  //   for (final item in _items) {
  //     map.putIfAbsent(item.group, () => []).add(item);
  //   }
  //   return map;
  // }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const ColoredBox(
        color: _Palette.background,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(color: _Palette.textSecondary),
          ),
        ),
      );
    }

    if (_error != null) {
      return ColoredBox(
        color: _Palette.background,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _error!,
              style: const TextStyle(color: _Palette.deleteBg),
            ),
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return ColoredBox(
        color: _Palette.background,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              widget.emptyMessage,
              style: const TextStyle(color: _Palette.textSecondary),
            ),
          ),
        ),
      );
    }

    // final grouped = _grouped();

    return ColoredBox(
      color: const Color.fromARGB(255, 23, 24, 28),
      child: ListView(
        padding: EdgeInsets.zero,
        children: _items
            .map(
              (item) => _NotificationTile(
                key: ValueKey(item.idNotification),
                item: item,
                onTap: () => _handleDelete(item),
                onDelete: () => _handleDelete(item),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final String title;
  const _GroupHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Text(
        title,
        style: const TextStyle(
          color: _Palette.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Item con swipe-to-delete
// ---------------------------------------------------------------------------

class _NotificationTile extends StatelessWidget {
  final NotificationPush item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('dismiss-${item.idNotification}'),
      direction: DismissDirection.endToStart,
      background: Container(color: const Color.fromARGB(255, 23, 24, 28)),
      secondaryBackground: Container(
        color: _Palette.deleteBg,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.close_rounded, color: _Palette.deleteFg),
            SizedBox(height: 2),
            Text(
              'Eliminar',
              style: TextStyle(
                color: _Palette.deleteFg,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (_) async => true,
      onDismissed: (_) => onDelete(),
      child: Container(
        // color: item.isRead ? _Palette.itemUnreadBg : _Palette.itemBg,
        color: const Color.fromARGB(255, 23, 24, 28),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Avatar(item: item),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: _Palette.textPrimary,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (item.body.isNotEmpty)... [
                        const SizedBox(height: 5),
                        Text(
                          item.body, 
                          style: const TextStyle(
                            color: _Palette.textSecondary,
                            fontSize: 13,
                          )
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDateDetails(item.sentAt.toString()),
                    style: const TextStyle(
                      color: _Palette.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (item.imgUrl != null) ...[
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imgUrl!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final NotificationPush item;
  const _Avatar({required this.item});

  @override
  Widget build(BuildContext context) {
    final style = getNotificationStyle(item.notificationType);
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: item.imgUrl != null
              ? Image.network(
                  item.imgUrl!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: _Palette.border,
                    width: 48,
                    height: 48,
                  ),
                )
              : Container(
                width: 48,
                height: 48,
                color: style.color.withOpacity(0.15),
                child: Icon(
                  style.icon,
                  color: style.color,
                  size: 26,
                ),
              ),
          ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                  border: Border.all(color: _Palette.itemBg, width: 2),
                ),
                child: Icon(
                  Icons.notifications,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}