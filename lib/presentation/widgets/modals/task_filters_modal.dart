import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/domain/entities/client_technical.dart';
import 'package:zentinel/domain/entities/location_technical.dart';
import 'package:zentinel/presentation/providers/providers.dart';

class TaskFilterSelection {
  final Set<int> clientIds;
  final Set<int> locationIds;

  const TaskFilterSelection({
    required this.clientIds,
    required this.locationIds,
  });
}

enum _TaskFilterView { summary, clients, locations }

class TaskFiltersModal extends ConsumerStatefulWidget {
  final Set<int> initialClientIds;
  final Set<int> initialLocationIds;

  const TaskFiltersModal({
    super.key,
    required this.initialClientIds,
    required this.initialLocationIds,
  });

  @override
  ConsumerState<TaskFiltersModal> createState() => _TaskFiltersModalState();
}

class _TaskFiltersModalState extends ConsumerState<TaskFiltersModal> {
  static const _accentColor = Color.fromARGB(255, 58, 199, 199);

  final _searchController = TextEditingController();
  late final Set<int> _selectedClientIds;
  late final Set<int> _selectedLocationIds;

  _TaskFilterView _currentView = _TaskFilterView.summary;
  String _searchText = '';
  bool _isLoadingOptions = true;
  bool _optionsLoadFailed = false;

  @override
  void initState() {
    super.initState();
    _selectedClientIds = {...widget.initialClientIds};
    _selectedLocationIds = {...widget.initialLocationIds};

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadOptions());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    if (mounted) {
      setState(() {
        _isLoadingOptions = true;
        _optionsLoadFailed = false;
      });
    }

    try {
      await Future.wait([
        ref.read(getClientsTechnical.notifier).load(),
        ref.read(getLocationTechnical.notifier).load(filters: const {}),
      ]);
    } catch (_) {
      _optionsLoadFailed = true;
    } finally {
      if (mounted) {
        setState(() => _isLoadingOptions = false);
      }
    }
  }

  void _openView(_TaskFilterView view) {
    FocusScope.of(context).unfocus();
    _searchController.clear();
    setState(() {
      _searchText = '';
      _currentView = view;
    });
  }

  void _clearAll() {
    setState(() {
      _selectedClientIds.clear();
      _selectedLocationIds.clear();
    });
  }

  void _apply() {
    Navigator.of(context).pop(
      TaskFilterSelection(
        clientIds: {..._selectedClientIds},
        locationIds: {..._selectedLocationIds},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mantener ambos providers escuchados mientras el modal está abierto evita
    // que el provider autoDispose de localizaciones se descarte durante la carga.
    final clients = ref.watch(getClientsTechnical);
    final locations = ref.watch(getLocationTechnical);

    return SafeArea(
      top: false,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                final beginOffset = _currentView == _TaskFilterView.summary
                    ? const Offset(-0.08, 0)
                    : const Offset(0.08, 0);

                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: beginOffset,
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _currentView == _TaskFilterView.summary
                  ? _buildSummary()
                  : _buildOptionsView(clients, locations),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final selectedCount =
        _selectedClientIds.length + _selectedLocationIds.length;

    return Padding(
      key: const ValueKey('task-filter-summary'),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filtros',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Elige uno o varios valores',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Cerrar',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _FilterCategoryTile(
            icon: Icons.business_outlined,
            title: 'Cliente',
            subtitle: _selectionSubtitle(_selectedClientIds.length),
            onTap: () => _openView(_TaskFilterView.clients),
          ),
          const SizedBox(height: 12),
          _FilterCategoryTile(
            icon: Icons.location_on_outlined,
            title: 'Localización',
            subtitle: _selectionSubtitle(_selectedLocationIds.length),
            onTap: () => _openView(_TaskFilterView.locations),
          ),
          const Spacer(),
          if (selectedCount > 0)
            Center(
              child: TextButton.icon(
                onPressed: _clearAll,
                icon: const Icon(Icons.filter_alt_off_outlined, size: 18),
                label: const Text('Limpiar filtros'),
                style: TextButton.styleFrom(foregroundColor: Colors.white70),
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: _apply,
              style: FilledButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: const Color(0xFF101415),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                selectedCount == 0
                    ? 'Aplicar filtros'
                    : 'Aplicar filtros ($selectedCount)',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _selectionSubtitle(int count) {
    if (count == 0) return 'Todas las opciones';
    if (count == 1) return '1 opción seleccionada';
    return '$count opciones seleccionadas';
  }

  Widget _buildOptionsView(
    List<ClientTechnical> clients,
    List<LocationTechnical> locations,
  ) {
    final isClientsView = _currentView == _TaskFilterView.clients;
    final title = isClientsView ? 'Cliente' : 'Localización';

    return Padding(
      key: ValueKey(_currentView),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Volver',
                onPressed: () => _openView(_TaskFilterView.summary),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (isClientsView) {
                      _selectedClientIds.clear();
                    } else {
                      _selectedLocationIds.clear();
                    }
                  });
                },
                child: const Text('Limpiar'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            autofocus: false,
            onChanged: (value) {
              setState(() => _searchText = value.trim().toLowerCase());
            },
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Buscar por nombre...',
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              suffixIcon: _searchText.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Borrar búsqueda',
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchText = '');
                      },
                      icon: const Icon(Icons.close, color: Colors.white54),
                    ),
              filled: true,
              fillColor: const Color(0xFF17181C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _accentColor),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _buildOptionList(
              isClientsView: isClientsView,
              clients: clients,
              locations: locations,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: () => _openView(_TaskFilterView.summary),
              style: FilledButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: const Color(0xFF101415),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Listo',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionList({
    required bool isClientsView,
    required List<ClientTechnical> clients,
    required List<LocationTechnical> locations,
  }) {
    if (_isLoadingOptions) {
      return const Center(
        child: CircularProgressIndicator(color: _accentColor),
      );
    }

    if (_optionsLoadFailed && clients.isEmpty && locations.isEmpty) {
      return _OptionsMessage(
        icon: Icons.cloud_off_outlined,
        message: 'No se pudieron cargar las opciones',
        actionLabel: 'Reintentar',
        onAction: _loadOptions,
      );
    }

    if (isClientsView) {
      final filteredClients =
          clients
              .where(
                (client) => client.name.toLowerCase().contains(_searchText),
              )
              .toList()
            ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
            );

      if (filteredClients.isEmpty) {
        return const _OptionsMessage(
          icon: Icons.search_off_outlined,
          message: 'No se encontraron clientes',
        );
      }

      return ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: filteredClients.length,
        separatorBuilder: (_, _) =>
            const Divider(height: 1, color: Colors.white10),
        itemBuilder: (context, index) {
          final client = filteredClients[index];
          final selected = _selectedClientIds.contains(client.idClient);

          return _SelectableOptionTile(
            title: client.name,
            selected: selected,
            onChanged: (value) {
              setState(() {
                if (value) {
                  _selectedClientIds.add(client.idClient);
                } else {
                  _selectedClientIds.remove(client.idClient);
                }
              });
            },
          );
        },
      );
    }

    final filteredLocations =
        locations
            .where(
              (location) => location.name.toLowerCase().contains(_searchText),
            )
            .toList()
          ..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );

    if (filteredLocations.isEmpty) {
      return const _OptionsMessage(
        icon: Icons.search_off_outlined,
        message: 'No se encontraron localizaciones',
      );
    }

    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: filteredLocations.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, color: Colors.white10),
      itemBuilder: (context, index) {
        final location = filteredLocations[index];
        final selected = _selectedLocationIds.contains(location.idLocation);

        return _SelectableOptionTile(
          title: location.name,
          subtitle: location.address,
          selected: selected,
          onChanged: (value) {
            setState(() {
              if (value) {
                _selectedLocationIds.add(location.idLocation);
              } else {
                _selectedLocationIds.remove(location.idLocation);
              }
            });
          },
        );
      },
    );
  }
}

class _FilterCategoryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FilterCategoryTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF17181C),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(35, 58, 199, 199),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: _TaskFiltersModalState._accentColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectableOptionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const _SelectableOptionTile({
    required this.title,
    this.subtitle,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!selected),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Checkbox(
              value: selected,
              onChanged: (value) => onChanged(value ?? false),
              activeColor: _TaskFiltersModalState._accentColor,
              checkColor: const Color(0xFF101415),
              side: const BorderSide(color: Colors.white38),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.white70,
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionsMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _OptionsMessage({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white38, size: 38),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
