import 'package:flutter/material.dart';

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

class NotificationList extends StatefulWidget {
  /// URL GET que retorna un array de notificaciones (o {"data": [...]}).
  final String? apiUrl;

  /// Alternativa a [apiUrl]: notificaciones ya cargadas por el padre.
  final List<NotificationItemModel>? notifications;

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
    this.notifications,
    this.deleteUrlBuilder,
    this.onDelete,
    this.emptyMessage = 'No tienes notificaciones.',
  }) : assert(
         apiUrl != null || notifications != null,
         'Provee apiUrl o notifications',
       );

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<NotificationItemModel> _items = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.notifications != null) {
      _items = widget.notifications!;
    } else {
      _fetch();
    }
  }

  @override
  void didUpdateWidget(covariant NotificationList old) {
    super.didUpdateWidget(old);
    if (widget.notifications != null &&
        widget.notifications != old.notifications) {
      setState(() => _items = widget.notifications!);
    }
  }

  Future<void> _fetch() async {
    if (widget.apiUrl == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    // try {
    //   final res = await http.get(Uri.parse(widget.apiUrl!));
    //   if (res.statusCode != 200) {
    //     throw Exception('Error ${res.statusCode} al obtener notificaciones');
    //   }
    //   final decoded = jsonDecode(res.body);
    //   final List rawList = decoded is List
    //       ? decoded
    //       : (decoded['data'] ?? decoded['notifications'] ?? []);
    //   setState(() {
    //     _items = rawList
    //         .map(
    //           (e) => NotificationItemModel.fromJson(e as Map<String, dynamic>),
    //         )
    //         .toList();
    //     _loading = false;
    //   });
    // } catch (e) {
    //   setState(() {
    //     _error = 'No se pudieron cargar las notificaciones.';
    //     _loading = false;
    //   });
    // }
  }

  Future<void> _handleDelete(NotificationItemModel item) async {
    if (widget.deleteUrlBuilder != null) {
      try {
        // await http.delete(Uri.parse(widget.deleteUrlBuilder!(item.id)));
      } catch (_) {
        // Si el borrado remoto falla igual quitamos el item localmente;
        // ajusta este comportamiento segun lo que necesite tu app.
      }
    }
    widget.onDelete?.call(item.id);
    setState(() => _items.removeWhere((n) => n.id == item.id));
  }

  Map<String, List<NotificationItemModel>> _grouped() {
    final map = <String, List<NotificationItemModel>>{};
    for (final item in _items) {
      map.putIfAbsent(item.group, () => []).add(item);
    }
    return map;
  }

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

    final grouped = _grouped();

    return ColoredBox(
      color: _Palette.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          for (final entry in grouped.entries) ...[
            if (entry.key.isNotEmpty) _GroupHeader(title: entry.key),
            for (final item in entry.value)
              _NotificationTile(
                key: ValueKey(item.id),
                item: item,
                onDelete: () => _handleDelete(item),
              ),
          ],
        ],
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
  final NotificationItemModel item;
  final VoidCallback onDelete;

  const _NotificationTile({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('dismiss-${item.id}'),
      direction: DismissDirection.endToStart,
      background: Container(color: _Palette.itemBg),
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
        color: item.unread ? _Palette.itemUnreadBg : _Palette.itemBg,
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
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: _Palette.textPrimary,
                        fontSize: 14.5,
                        height: 1.35,
                      ),
                      children: [
                        TextSpan(
                          text: item.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        if (item.body.isNotEmpty)
                          TextSpan(text: ' ${item.body}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.time,
                    style: const TextStyle(
                      color: _Palette.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (item.thumbnailUrl != null) ...[
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.thumbnailUrl!,
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
  final NotificationItemModel item;
  const _Avatar({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: item.avatarUrl != null
                ? Image.network(
                    item.avatarUrl!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: _Palette.border,
                      width: 48,
                      height: 48,
                    ),
                  )
                : Container(color: _Palette.border, width: 48, height: 48),
          ),
          // if (item.badge != NotificationBadge.none)
          //   Positioned(
          //     right: -2,
          //     bottom: -2,
          //     child: Container(
          //       width: 20,
          //       height: 20,
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: item.badgeColor,
          //         border: Border.all(color: _Palette.itemBg, width: 2),
          //       ),
          //       child: Icon(
          //         _iconForBadge(item.badge),
          //         size: 12,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
